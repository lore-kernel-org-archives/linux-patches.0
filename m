Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4742526F462;
	Tue, 25 Mar 2025 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906382; cv=none; b=tiFZxteTDiVEwL9peaFtB/TdiHzzeetRC4EAvIlO0/lGVbvFaKmOr40KXyIm8O1actlsqGzHjIal8Axw4tOuuUacrBkVvtJguT+Vz+gbwbLiqlvZ5G2MbR4KP/UNDzoCNyAYwPBnvU4YnLHOQ/sTQEolktaiO4fr5y47b+QgY8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906382; c=relaxed/simple;
	bh=+rS6IsJdqCoboO0mhBxiI826BG7T7bSmTTVJuBgjMLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjzE18qymZF12fzGy8HoacBBbTVjG3DqMRyg7/bE38uGsVGAt4EAv2+EmjoLG3AUlPSNfVFF3N8WGMQV2sV+q4MXsTlZrbblOFGyg1yllfTnStdHUaitmMPc9+r4SkeYTZ/zeISZP+qhYa233cvgeQWLAHHHNwzRfEJje5VLK4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSsbyyyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSsbyyyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC1AC4CEE4;
	Tue, 25 Mar 2025 12:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906382;
	bh=+rS6IsJdqCoboO0mhBxiI826BG7T7bSmTTVJuBgjMLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSsbyyydCnPqUAy+UGsntPi82ocoLQVzihuyAA8hIyyna5q0k534J+NpOrZhQd5ER
	 BIMiRfZc97qNzGTbInj9wyiys89q5g0c9Rl2XZ841PkeKavZ9mGF9E3JlTujsCSSFU
	 9ANE9HO0omH9K3tVcSGeFYyZTB2Sh8cxRxVV4OjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Saranya R <quic_sarar@quicinc.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 087/116] soc: qcom: pdr: Fix the potential deadlock
Date: Tue, 25 Mar 2025 08:22:54 -0400
Message-ID: <20250325122151.434375717@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saranya R <quic_sarar@quicinc.com>

commit 2eeb03ad9f42dfece63051be2400af487ddb96d2 upstream.

When some client process A call pdr_add_lookup() to add the look up for
the service and does schedule locator work, later a process B got a new
server packet indicating locator is up and call pdr_locator_new_server()
which eventually sets pdr->locator_init_complete to true which process A
sees and takes list lock and queries domain list but it will timeout due
to deadlock as the response will queued to the same qmi->wq and it is
ordered workqueue and process B is not able to complete new server
request work due to deadlock on list lock.

Fix it by removing the unnecessary list iteration as the list iteration
is already being done inside locator work, so avoid it here and just
call schedule_work() here.

       Process A                        Process B

                                     process_scheduled_works()
pdr_add_lookup()                      qmi_data_ready_work()
 process_scheduled_works()             pdr_locator_new_server()
                                         pdr->locator_init_complete=true;
   pdr_locator_work()
    mutex_lock(&pdr->list_lock);

     pdr_locate_service()                  mutex_lock(&pdr->list_lock);

      pdr_get_domain_list()
       pr_err("PDR: %s get domain list
               txn wait failed: %d\n",
               req->service_name,
               ret);

Timeout error log due to deadlock:

"
 PDR: tms/servreg get domain list txn wait failed: -110
 PDR: service lookup for msm/adsp/sensor_pd:tms/servreg failed: -110
"

Thanks to Bjorn and Johan for letting me know that this commit also fixes
an audio regression when using the in-kernel pd-mapper as that makes it
easier to hit this race. [1]

Link: https://lore.kernel.org/lkml/Zqet8iInnDhnxkT9@hovoldconsulting.com/ # [1]
Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
CC: stable@vger.kernel.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Tested-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Saranya R <quic_sarar@quicinc.com>
Co-developed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250212163720.1577876-1-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/pdr_interface.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -75,7 +75,6 @@ static int pdr_locator_new_server(struct
 {
 	struct pdr_handle *pdr = container_of(qmi, struct pdr_handle,
 					      locator_hdl);
-	struct pdr_service *pds;
 
 	mutex_lock(&pdr->lock);
 	/* Create a local client port for QMI communication */
@@ -87,12 +86,7 @@ static int pdr_locator_new_server(struct
 	mutex_unlock(&pdr->lock);
 
 	/* Service pending lookup requests */
-	mutex_lock(&pdr->list_lock);
-	list_for_each_entry(pds, &pdr->lookups, node) {
-		if (pds->need_locator_lookup)
-			schedule_work(&pdr->locator_work);
-	}
-	mutex_unlock(&pdr->list_lock);
+	schedule_work(&pdr->locator_work);
 
 	return 0;
 }


