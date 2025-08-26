Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D6135209D;
	Tue, 26 Aug 2025 14:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218364; cv=none; b=ayTolsOok6vSckSLi6x3eUorXukD7asbriBtfHt7/swLxVmutk6TQJRtKa/4Qm+yeR3mBn/qAmDzfkihZ5mLUkheHlm/L9LT6+1GAImZaEoVJlOQ131FK1d1+4Zk+j2NTMoJsC7bi9RcEMkXOXabfGkdxdS+U39SJFkF73F+/nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218364; c=relaxed/simple;
	bh=IqMzwS71x1NQRI+nGlbmmmN/jPmznvvD9sm/wpQ4j6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFRhy/pTBj0w8eSL6WxI1mJGyTXd5jPau5v7KegrH6lEP/OfHuotq0g3qDOrr7R/6ZNhofXagYRJivbRQo3EGMHXZcQgt+6plkm0DPWd61rKBmJ/OiqNxOlyr28D14QhroNajVQiFSbTA++fcf4hTHff+vmoLMvZ5myBme8NX3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zK9CdFeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zK9CdFeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59183C4CEF1;
	Tue, 26 Aug 2025 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218363;
	bh=IqMzwS71x1NQRI+nGlbmmmN/jPmznvvD9sm/wpQ4j6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zK9CdFeO7pDsaX1vc2RQmhfNTRIzW0b6zXm754WL7JnfVRkLksL+QXfk2SnVS3gLh
	 lZv0Gh6M/80wCDLUz/ZJHVJWK3xGc0dc8QL4JO4G4rullW9FQjG8DZNMAfTcuhnMkE
	 chajPqN9I9TpI8bN6gf19Ixs5EmI7LI+H4GWlM5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 493/523] uio_hv_generic: Fix another memory leak in error handling paths
Date: Tue, 26 Aug 2025 13:11:43 +0200
Message-ID: <20250826110936.605246904@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 0b0226be3a52dadd965644bc52a807961c2c26df upstream.

Memory allocated by 'vmbus_alloc_ring()' at the beginning of the probe
function is never freed in the error handling path.

Add the missing 'vmbus_free_ring()' call.

Note that it is already freed in the .remove function.

Fixes: cdfa835c6e5e ("uio_hv_generic: defer opening vmbus until first use")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0d86027b8eeed8e6360bc3d52bcdb328ff9bdca1.1620544055.git.christophe.jaillet@wanadoo.fr
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -306,7 +306,7 @@ hv_uio_probe(struct hv_device *dev,
 	pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);
 	if (pdata->recv_buf == NULL) {
 		ret = -ENOMEM;
-		goto fail_close;
+		goto fail_free_ring;
 	}
 
 	ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
@@ -366,6 +366,8 @@ hv_uio_probe(struct hv_device *dev,
 
 fail_close:
 	hv_uio_cleanup(dev, pdata);
+fail_free_ring:
+	vmbus_free_ring(dev->channel);
 
 	return ret;
 }


