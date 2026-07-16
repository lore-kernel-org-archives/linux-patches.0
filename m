Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FE4427A04;
	Thu, 16 Jul 2026 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212270; cv=none; b=mnp5aI2x+v7H8fZYY3HbQ4mBh9hbz/dgaK7rL91YUXc6nJlOyromONihLTTKlr9D+odOE34iYl6H9X+FyMpehp/tlspXLbv16QU3MIGsJQPGOSGaS0SRXsXaYhIC6Fyc5Ka2KftRaGOIST6g7tQXzRKMA6ocTeWRk62YCvkOqUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212270; c=relaxed/simple;
	bh=/JjafkfgPA019FN3lKdgLJVGZhXn89OfXfIBndWnfQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPwdBqxxwT8kt1C9hBFTgFIa+M3XFgcJkyAg//YPC1Kk1C07/16LwY75CBXfdzPIMqK/o8dxOJrzcsz+p+76Nq00zg/lXUCmiRGuuRVZ2ZXtqtlqZhgcdwvmZUbU4KzyT6IjI5fPwrMZgyiRGXnu2Tta4QkMjVuqzjdFCjT0P8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdlP2rgs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdlP2rgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D301F00A3F;
	Thu, 16 Jul 2026 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212268;
	bh=cRFBKClZv5/LqegUHKXqEJy8wvWitr8YfwkwucHmcjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdlP2rgsaSo8v4618KScb+hTabUTab+hnL5pZxSIA72SeY2CB/g3PanpJ0u+J6us1
	 yHNE9APuEZ+Bm78Lm/1QpWPgcCcF6c0ZGRRl0qcJHTLwE/7HOF8USPYcY1YHpq9U/g
	 9Vuw/aKe0gs09qkJ6CwxR0gbOpPOhr40Gdu06gAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6.12 263/349] dm-ioctl: report an error if a device has no table
Date: Thu, 16 Jul 2026 15:33:17 +0200
Message-ID: <20260716133039.233606846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 457e32348d606a77f9b20e25e989734189834c07 upstream.

When we send a message to a device that has no table, the return code was
not set. The code would return "2", which is not considered a valid return value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1806,8 +1806,11 @@ static int target_message(struct file *f
 		goto out_argv;
 
 	table = dm_get_live_table(md, &srcu_idx);
-	if (!table)
+	if (!table) {
+		DMERR("The device has no table.");
+		r = -EINVAL;
 		goto out_table;
+	}
 
 	if (dm_deleting_md(md)) {
 		r = -ENXIO;


