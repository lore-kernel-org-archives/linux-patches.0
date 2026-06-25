Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CB12E040D;
	Thu, 25 Jun 2026 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393087; cv=none; b=Tm45j+ZZ/p0zdOz6o8sAURhbMy3gDD/v4p+6yysOcm5NODMb5g9Zr3Rdi9WaG0IagpjGvmyZ7O0a9R1DRO+JgYJPwyox471r06jLu7EGnK5sLgaN8G1/eRJUAGOWF4KcXKKb3wa/mlj/B5F9gQQDd+NM4764gPxtiWHprpZPTNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393087; c=relaxed/simple;
	bh=ykh3TojpqrRa+/noSNX9YebH8TqK+RmTAj+8c59KwsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBuMmeGluCCUY0DCpV94UWdfXvZlr4PJsEmbUGp7qy9OxQy2K7l613WBu6/3ZddiMphsJS99cKhtKKMDE6wmXDCCLHf111EsBVjcVSOSEcpgatfHmoFGW3/Tdqn5wXyaUYTSKM2pjRlCcLrH6O+XtzgYwxqmBnOcr4BFE8q1XaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnZ+GnUl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnZ+GnUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7428C1F00A3A;
	Thu, 25 Jun 2026 13:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393084;
	bh=/IRnVEAVKNMhskMTdqGTRx7fMWvjUV9B2NV/WF9+cSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnZ+GnUlTMDDzj+1SKufV5leJVNX/t/q2uZMxVDNxXh3JPgKHewmHYSKpErYqGG+v
	 vTM/vvXBxRkn7TZhyKugMETe8ocLocrqcDQ4TQXmtK3+RgOyjkYdhZuzXa9WN3ij3y
	 hLpToZBWBrwwOGYQccdFmNiGNnnE8n3gddiBoNkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 39/49] Input: rmi4 - fix memory leak in rmi_set_attn_data()
Date: Thu, 25 Jun 2026 14:03:51 +0100
Message-ID: <20260625125643.006722248@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit a55a683a8e2bddb5467baab3e597a93022d4ee05 upstream.

kfifo_put() returns 0 if the FIFO is full. In this case, we must
free the memory allocated for the attention data to avoid a leak.

Fixes: b908d3cd812a ("Input: synaptics-rmi4 - allow to add attention data")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-5-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -183,7 +183,11 @@ void rmi_set_attn_data(struct rmi_device
 	attn_data.size = size;
 	attn_data.data = fifo_data;
 
-	kfifo_put(&drvdata->attn_fifo, attn_data);
+	if (!kfifo_put(&drvdata->attn_fifo, attn_data)) {
+		dev_warn_ratelimited(&rmi_dev->dev,
+				     "Failed to enqueue attention data, FIFO full\n");
+		kfree(fifo_data);
+	}
 }
 EXPORT_SYMBOL_GPL(rmi_set_attn_data);
 


