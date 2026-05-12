Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787603D45ED;
	Tue, 12 May 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608350; cv=none; b=Kv+bgp8k84yl/fWC8ZcvjOTKsw/XuU1MMo+Qh5MwYqCogszntCviSiCuvTnkyyRtrIyYDNbQc36UJOsXjBfbUxgAwP6qzkS07ikQgockrT3ystb5XzdT3mDxSF64KFrlHI0MBjqGS/hwD3kMfIcEuCchNprcPFuqa2bTyOT/qyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608350; c=relaxed/simple;
	bh=20WK3yRwnLPav4ti0nMdzwyWhBA0pPaSGzSgzVhyYD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGzyttXDFJSogMRhZEQVSctvg+wsitzV8aa60KugFTf0vzXrdYMEI4dmpI9MxZkoHUFS3W3iSAsRA6263evSuQWxTjfQPYqJlVNey+uUshplyLoMuxc2p9Q/WMePUOa1DhB2IWIFHx+f28uDLcB9+9HwO09+u77B9oJe4cVXP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNtPNlvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNtPNlvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4C2C2BCB0;
	Tue, 12 May 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608350;
	bh=20WK3yRwnLPav4ti0nMdzwyWhBA0pPaSGzSgzVhyYD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNtPNlvNEeqvOQJeHj+1laalW/1BSi3aEnA+gR6hZ2UzFMqYNps9uYJOeHIzDz2MK
	 Btks9Vrkuh9m48XnSbJhlsK0rq7OvzEJrVAo4dnUn3op5w7ZThRz/chk+E0ApsDXsR
	 2Jc9hGvJ3o+UDygLOyjtxVX4m0pho6EpBUKY3zws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 046/270] usb: ulpi: fix memory leak on ulpi_register() error paths
Date: Tue, 12 May 2026 19:37:27 +0200
Message-ID: <20260512173939.421973772@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 0b9fcab1b8608d429e5f239afb197de928d4de7d upstream.

Commit 01af542392b5 ("usb: ulpi: fix double free in
ulpi_register_interface() error path") removed kfree(ulpi) from
ulpi_register_interface() to fix a double-free when device_register()
fails.

But when ulpi_of_register() or ulpi_read_id() fail before
device_register() is called, the ulpi allocation is leaked.

Add kfree(ulpi) on both error paths to properly clean up the allocation.

Fixes: 01af542392b5 ("usb: ulpi: fix double free in ulpi_register_interface() error path")
Cc: stable <stable@kernel.org>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260407-ulpi-v1-1-f3fafe53f7b2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -286,12 +286,15 @@ static int ulpi_register(struct device *
 	ACPI_COMPANION_SET(&ulpi->dev, ACPI_COMPANION(dev));
 
 	ret = ulpi_of_register(ulpi);
-	if (ret)
+	if (ret) {
+		kfree(ulpi);
 		return ret;
+	}
 
 	ret = ulpi_read_id(ulpi);
 	if (ret) {
 		of_node_put(ulpi->dev.of_node);
+		kfree(ulpi);
 		return ret;
 	}
 


