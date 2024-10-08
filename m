Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D1818F2FA;
	Tue,  8 Oct 2024 13:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392494; cv=none; b=M6JVYxouKukfG3SenYwd8Ccpzrry+kIMmFB1YU7sdr2IUXABQmTeZDVGrbW2Fl9OVIAfNBZ+veck5sAatxKhIAbfKmyFIDJJRfoxabIEsTt7qs9GmYy3tIbHw74qT9A/6IIMqRXitn9WaaVmmmyVlW4mkG/kSNcjktOMWHc8UXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392494; c=relaxed/simple;
	bh=aOyJtIr//clOoR/PkKpvZo7iuWtfAWOvKXE2YXLQnmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3g6gxqzYWmsFoeFfHtV2zoE/dvZE9K3ZaVHV7XBZHBcraNwJ/CbNrTkTF+MjbEt+LJSj4nUJSXg5WrNdN6NocrxD4zfOZNSEQ6LAPgrhnFiJTjTbBrj27kP+bxatT9v3T6jH7bSeY8ePm4JG+ptGaCJaz9RXUo8AR1n8+1oAIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/Q8zpVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/Q8zpVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F5FC4CEC7;
	Tue,  8 Oct 2024 13:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392494;
	bh=aOyJtIr//clOoR/PkKpvZo7iuWtfAWOvKXE2YXLQnmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/Q8zpVvEgNcSu4PCdl4W8/9VNFNlCaOgdVggU6RpGvCfHCCGH3YCCxW57esMoYs8
	 D3V8LiTECqEzPwbIlprZzOm/73UBNELtjFXZ9bYghfjKTX+YIUdtbf8/y6rH1SshFB
	 Aa9o/Knp+HFKbrU7p9QkGdClZFWodBRz/iiNWydk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.11 431/558] exfat: fix memory leak in exfat_load_bitmap()
Date: Tue,  8 Oct 2024 14:07:41 +0200
Message-ID: <20241008115719.233612962@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit d2b537b3e533f28e0d97293fe9293161fe8cd137 upstream.

If the first directory entry in the root directory is not a bitmap
directory entry, 'bh' will not be released and reassigned, which
will cause a memory leak.

Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
Cc: stable@vger.kernel.org
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/balloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -91,11 +91,8 @@ int exfat_load_bitmap(struct super_block
 				return -EIO;
 
 			type = exfat_get_entry_type(ep);
-			if (type == TYPE_UNUSED)
-				break;
-			if (type != TYPE_BITMAP)
-				continue;
-			if (ep->dentry.bitmap.flags == 0x0) {
+			if (type == TYPE_BITMAP &&
+			    ep->dentry.bitmap.flags == 0x0) {
 				int err;
 
 				err = exfat_allocate_bitmap(sb, ep);
@@ -103,6 +100,9 @@ int exfat_load_bitmap(struct super_block
 				return err;
 			}
 			brelse(bh);
+
+			if (type == TYPE_UNUSED)
+				return -EINVAL;
 		}
 
 		if (exfat_get_next_cluster(sb, &clu.dir))


