Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F63B471438;
	Tue, 21 Jul 2026 20:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665335; cv=none; b=DJDsHgtEm6RvhWXCkNxfLWIO1JgW/JkmZH64/X8n7ytCDwbBLBB1QxXJv+t6pycK21l7kutNc2kSKr4k0/hBO4nWFi64AyHdQMkw2k6XTWUhZJ4L7XmS5TZrqktkXuavol4DAy/a6Veq5k56Gd6YPw4jEqZWwgqxuV3rIJt/zxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665335; c=relaxed/simple;
	bh=2Gq+RwSWYQEDnS2y5mLjrmeVFRNg7qyJl0UJ1Ep1WZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvQitgMjtTXuv3L7rcITOTMkGcs1CENncFHWXsvPZx1mIwjmanaaGKWdu3shoZb05T5Kr+Z9MjzGjQhMTY9o4MGnWUmaDwkWW62LQ4TOIl/lxjNH/FdF1A92yhu/LFH8tj23qqC4tm9JENzcamegMafzGcftQA0H/IuNqkNquVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWNuArz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWNuArz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AA81F000E9;
	Tue, 21 Jul 2026 20:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665334;
	bh=9HTrlBxqFROhoN28DhqF8uHmmmVcGCZ/c+X7wdrEpI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWNuArz+fRXIHCn4jSlYtEaNhInEmSaWBK/2DuoW1ebTzulv3xJ7FJkhKN68HZ+3X
	 uEoG3Hpoe2adLIlXFC8WxLVCmYF9EKx8iHG690oSXhwDw2AUYPw+5a0zFIHppmTZ/I
	 48JFwfK1AzPUhfAsXu5JuUKMnUgajLlstQVGAuxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6.6 0264/1266] dm-ioctl: report an error if a device has no table
Date: Tue, 21 Jul 2026 17:11:41 +0200
Message-ID: <20260721152447.727539812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


