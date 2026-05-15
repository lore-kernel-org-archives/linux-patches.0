Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0393C0A13;
	Fri, 15 May 2026 16:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861122; cv=none; b=XmuMkV5ZtJtTqxGufkskjmrLfBKqYZbfGwTaFRn9UFeAKGbFXbzohWJ8JnBY1/fHlZCZ0JDqsQPyPcWm1LD0kq9czAyWxFOAbzrUld2aXmSuFkxYBxz7b2l/GhTYdwJ50TK2+65eK6Tkw8FbxqMUby00tq180jw8crwMJ+veztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861122; c=relaxed/simple;
	bh=Y0pW0P7Dy/Di8qfgUBo8u3LOQl44/nYtuvMavXteP5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqVFn+MWcINQrlKPhfv70MU+Nl0rHmVJ8IRLKZnUTwMPkxdGUmD6wQ2JJ4oU+SZNY6IIgRkklNn1Eoxngs0NAeZZ+dSEI9L+24ByfFF4a4kMkRrE/0jeIxksSEfI7WUXICE8LRQ7rtp25UvRPq2XWQVmmw1Jbx2SXytwCyZB0Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9x0mSYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9x0mSYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021CDC2BCB3;
	Fri, 15 May 2026 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861122;
	bh=Y0pW0P7Dy/Di8qfgUBo8u3LOQl44/nYtuvMavXteP5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9x0mSYmAWZ+Lq3MBV8MvPvxktDe91FHejwpdhGuqbweiLMUI1m2yaaTZdAgm8olY
	 lNrttMA2lroiNcaPySodz1S2zI/AQVCSlLK0P06sUo2XVfM4Fu4c0tAW7DiAyGjuKz
	 7FJ54PdS7wr+Xkkmcl3LflXqqAbG1ULs8Fn22jSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 200/474] usb: ulpi: fix memory leak on ulpi_register() error paths
Date: Fri, 15 May 2026 17:45:09 +0200
Message-ID: <20260515154719.343952091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


