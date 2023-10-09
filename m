Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E804D1A71F
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNxsYBc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187FBC433C8;
	Mon,  9 Oct 2023 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858337;
	bh=ShR56LiGQG3OF//TRPuGYfCo9gn2PQlUMwbm4q6pkG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNxsYBc+Q4Lk1NIaWwFk+8bppluxAP6TsElXjj7W77EHnRp9N/HX2D7Ki6J7Zc54e
	 K0efJE8/1IMotuueBuZw2rXtK88WR2NQpi2D4XMDKWhv4YUoCuj/1Vjn/Oga8lSsCb
	 NFpm5ywBTA4QV7fmE/GVpCjcQ49hkiZLu9pU0YXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Benjamin Block <bblock@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 091/131] scsi: zfcp: Fix a double put in zfcp_port_enqueue()
Date: Mon,  9 Oct 2023 15:02:11 +0200
Message-ID: <20231009130119.162953175@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit b481f644d9174670b385c3a699617052cd2a79d3 upstream.

When device_register() fails, zfcp_port_release() will be called after
put_device(). As a result, zfcp_ccw_adapter_put() will be called twice: one
in zfcp_port_release() and one in the error path after device_register().
So the reference on the adapter object is doubly put, which may lead to a
premature free. Fix this by adjusting the error tag after
device_register().

Fixes: f3450c7b9172 ("[SCSI] zfcp: Replace local reference counting with common kref")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20230923103723.10320-1-dinghao.liu@zju.edu.cn
Acked-by: Benjamin Block <bblock@linux.ibm.com>
Cc: stable@vger.kernel.org # v2.6.33+
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/scsi/zfcp_aux.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -488,12 +488,12 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	if (port) {
 		put_device(&port->dev);
 		retval = -EEXIST;
-		goto err_out;
+		goto err_put;
 	}
 
 	port = kzalloc(sizeof(struct zfcp_port), GFP_KERNEL);
 	if (!port)
-		goto err_out;
+		goto err_put;
 
 	rwlock_init(&port->unit_list_lock);
 	INIT_LIST_HEAD(&port->unit_list);
@@ -516,7 +516,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	if (dev_set_name(&port->dev, "0x%016llx", (unsigned long long)wwpn)) {
 		kfree(port);
-		goto err_out;
+		goto err_put;
 	}
 	retval = -EINVAL;
 
@@ -533,7 +533,8 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	return port;
 
-err_out:
+err_put:
 	zfcp_ccw_adapter_put(adapter);
+err_out:
 	return ERR_PTR(retval);
 }


