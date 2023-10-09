Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C4A182DF
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yb6mDv1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFD8C433C8;
	Mon,  9 Oct 2023 13:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856898;
	bh=tsYpO0lc6QtRAJ4AVd67p8qSuCUiQ4oTan3Dl9/F7Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yb6mDv1kZdFNMQJ+sSejQrRLKU6M4LSYhzx4PrIP0qaw8PdCiRJou6fH58mEBJ6Aq
	 ON84YXpL0yuL4TqsKV/w3XbyNBB91/IATa5audM0C9XX8Cj2QlAVeiUoQqqMDeqIjE
	 BJD9F+XJpfX6QxXr0YydlABXOe7Mk8FpnmjSMYtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Benjamin Block <bblock@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 027/163] scsi: zfcp: Fix a double put in zfcp_port_enqueue()
Date: Mon,  9 Oct 2023 14:59:51 +0200
Message-ID: <20231009130124.756731026@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -518,12 +518,12 @@ struct zfcp_port *zfcp_port_enqueue(stru
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
@@ -546,7 +546,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	if (dev_set_name(&port->dev, "0x%016llx", (unsigned long long)wwpn)) {
 		kfree(port);
-		goto err_out;
+		goto err_put;
 	}
 	retval = -EINVAL;
 
@@ -563,7 +563,8 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	return port;
 
-err_out:
+err_put:
 	zfcp_ccw_adapter_put(adapter);
+err_out:
 	return ERR_PTR(retval);
 }


