Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2A73F23BF;
	Tue, 17 Mar 2026 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766010; cv=none; b=P4vck+oSaw9CJyZKlvfn23S55lt0UhWUG1q7T7zFHgaqjswEQwurWwhj8EJRsGE/z+ysDi1stYEOMUKg4k8N0M3badXD8p27mEwlxsl5ICs+lV/6PwAY3hscS50n6mf0VCzbODFoTAEjWGuoB/AGRm/tR31qhN4PkCFTfELEu2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766010; c=relaxed/simple;
	bh=8K/GtWjbLIZ401ULQQKI54G/4LDswNruLDtScETX5PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X797B+l9VnHBCI+YZSS7mFe6CAvQe8lgT6JVm/X+UpCgALis0WP9SwVmT5YbDp9YtUPgC23aDxG9Ethk83nv0+8n2tAp0G2jI5lydh5DrUwcDeQ80+IZcpwYjTYG9KUTwESC8/inLTKrLgqQ/2sgPQ75LqPm8//EXWlfx7orAyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wb13A0pR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wb13A0pR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1A9C4CEF7;
	Tue, 17 Mar 2026 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766009;
	bh=8K/GtWjbLIZ401ULQQKI54G/4LDswNruLDtScETX5PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wb13A0pRfbETsG92GPsoqCunAc+uvV4lc60T18wxopazD55ApSeP2NcvSa/gWuaSg
	 SgLyVNmMT1l1h8K+j7olSNBzJY1fnosbFByhd5qIYAliL18jBN1YjbECydv2u0P/U7
	 PDdzemjarV+HGFacxggzc1J1rFgJbT8ueZfS5Pqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 150/378] usb: misc: uss720: properly clean up reference in uss720_probe()
Date: Tue, 17 Mar 2026 17:31:47 +0100
Message-ID: <20260317163012.531457338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 45dba8011efac11a2f360383221b541f5ea53ce5 upstream.

If get_1284_register() fails, the usb device reference count is
incorrect and needs to be properly dropped before returning.  That will
happen when the kref is dropped in the call to destroy_priv(), so jump
to that error path instead of returning directly.

Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Link: https://patch.msgid.link/2026022342-smokiness-stove-d792@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/uss720.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -736,7 +736,7 @@ static int uss720_probe(struct usb_inter
 	ret = get_1284_register(pp, 0, &reg, GFP_KERNEL);
 	dev_dbg(&intf->dev, "reg: %7ph\n", priv->reg);
 	if (ret < 0)
-		return ret;
+		goto probe_abort;
 
 	ret = usb_find_last_int_in_endpoint(interface, &epd);
 	if (!ret) {


