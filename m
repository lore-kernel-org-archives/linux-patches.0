Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B4A1D0797;
	Wed,  2 Oct 2024 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878785; cv=none; b=tLlG5AWNGV8ndRDLrYxOJJY/lx8PqRyR8re3t32AjV1bIg4qOrAw1fxhrYqXBaW6cAqV+0FOPxsQiuagYf6e3sPR74bPkFpnHRQLvm0OIrNCTnaGB+ksiWTAb5+iUm1m3FSomWTjTnuSSNPtFxvMv+X+rW9nUb+4C+HL0IsvdP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878785; c=relaxed/simple;
	bh=GKrib7ROOz7i4G0WaoEYg91uLAkXXNT3k5LSBa7TVxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rsqh3ZaBf8Rq06RE0tOwP/zXwvjz146/2S1VasXCn7MrS9NrKFBYaCZww5y25iEpDWuukAU35NM86mQOpsydqrHjIHR22uNEH8y0KggSlms7JCgE0zAcuPFt5mnmBYmoENRo4xejpd6tpNEHBD/+FK0+EqUiqoic32atGcxYHOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naTes1Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naTes1Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B09C4CEC2;
	Wed,  2 Oct 2024 14:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878785;
	bh=GKrib7ROOz7i4G0WaoEYg91uLAkXXNT3k5LSBa7TVxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naTes1OkP3w+/PHnBUnD1EidNcIIy9wf6FpSaT7+sDGa8Okvqtkki7OgNoz51Sg9+
	 i+UVUFXHL5y8cCIWNjdvk41VI3K6d0pcFNynMuYB4nte88lZ5NE8ek4h7m0EKNnIBC
	 rXE8MmXM2lvLegGyMlhrlPfdBXjCwTZHUAgcyjlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 6.10 531/634] pps: add an error check in parport_attach
Date: Wed,  2 Oct 2024 15:00:31 +0200
Message-ID: <20241002125832.065163260@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 62c5a01a5711c8e4be8ae7b6f0db663094615d48 upstream.

In parport_attach, the return value of ida_alloc is unchecked, witch leads
to the use of an invalid index value.

To address this issue, index should be checked. When the index value is
abnormal, the device should be freed.

Found by code review, compile tested only.

Cc: stable@vger.kernel.org
Fixes: fb56d97df70e ("pps: client: use new parport device model")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/20240828131814.3034338-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pps/clients/pps_parport.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -149,6 +149,9 @@ static void parport_attach(struct parpor
 	}
 
 	index = ida_alloc(&pps_client_index, GFP_KERNEL);
+	if (index < 0)
+		goto err_free_device;
+
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -159,7 +162,7 @@ static void parport_attach(struct parpor
 						    index);
 	if (!device->pardev) {
 		pr_err("couldn't register with %s\n", port->name);
-		goto err_free;
+		goto err_free_ida;
 	}
 
 	if (parport_claim_or_block(device->pardev) < 0) {
@@ -187,8 +190,9 @@ err_release_dev:
 	parport_release(device->pardev);
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
-err_free:
+err_free_ida:
 	ida_free(&pps_client_index, index);
+err_free_device:
 	kfree(device);
 }
 


