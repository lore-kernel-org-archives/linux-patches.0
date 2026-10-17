Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E06A321445;
	Sat, 17 Oct 2026 16:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253771; cv=none; b=hGEzW5DJ0WXqPPYDoQS13PJ0+Si1fA8XTRbF/OGuvZEoJkKB+r2FyQAfCOr88y4PDGjC/uU80KLs75Q0hvhTJBvJZjAAv1+abFHoGoRPM2AXObn2hBvyLueHNk3LnIh1ZVf1tzlZKodtXXffBMLd4JZBH3uZ9wpiNS++KUP6BVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253771; c=relaxed/simple;
	bh=z7nM986wFt+8Db4AilKuy/yFijEFSdQqYqYOg/qxj2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYByjjhZQ1eJshsM4v3LuV8mNSHnGbP14Nur28+MAIp6xtUNm1//4eFNkoXIH8qi3/mw+VmHL7wgSDcYK4v/W4x+9A9u9VmrIzrd416l8Zz/XnwZBCnHcKuMPqFsq8zNXGPReaGXNMgTLjimauiU7JaEeCrBCqfD874WHOTwT9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FY/BcjyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FY/BcjyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895BF1F000C4;
	Sat, 17 Oct 2026 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253770;
	bh=sBRuoYXO4iNFEh/0LnLtgW2q7Nv9sWu6Yz7TbdM40yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FY/BcjyKppQAXu5SUHjbBZtDl56Q1V9LKtrdcxJVEui4LYl6D6PjIRmaL8q38qH1X
	 /HPdpAlug7nUNQiengHyXZZ5F2cyzkvp0rF/s6NHgUug7N8eWSzDMg7PFVlgopS+OY
	 volXSw9lxa3sdNOqbEEAi/IXOqwwNvQdn3ZydZQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatsuya S <tatsuya.s2862@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/869] HID: core: Add reserved item tag for main items
Date: Sat, 17 Oct 2026 17:51:08 +0200
Message-ID: <20261017160042.869452295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Tatsuya S <tatsuya.s2862@gmail.com>

[ Upstream commit c600a55922640b1c4dcfdc5a694cadd2dd9d1599 ]

For main items, separate warning of reserved item tag from
warning of unknown item tag.
This comes from 6.2.2.4 Main Items of Device Class Definition
for HID 1.11 specification.

Signed-off-by: Tatsuya S <tatsuya.s2862@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 6 +++++-
 include/linux/hid.h    | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index df2e43b27388d..ba6d42a3e634e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -670,7 +670,11 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
 		ret = hid_add_field(parser, HID_FEATURE_REPORT, data);
 		break;
 	default:
-		hid_warn(parser->device, "unknown main item tag 0x%x\n", item->tag);
+		if (item->tag >= HID_MAIN_ITEM_TAG_RESERVED_MIN &&
+			item->tag <= HID_MAIN_ITEM_TAG_RESERVED_MAX)
+			hid_warn(parser->device, "reserved main item tag 0x%x\n", item->tag);
+		else
+			hid_warn(parser->device, "unknown main item tag 0x%x\n", item->tag);
 		ret = 0;
 	}
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index e2734b9d3ee05..89529c58da0a4 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -81,6 +81,8 @@ struct hid_item {
 #define HID_MAIN_ITEM_TAG_FEATURE		11
 #define HID_MAIN_ITEM_TAG_BEGIN_COLLECTION	10
 #define HID_MAIN_ITEM_TAG_END_COLLECTION	12
+#define HID_MAIN_ITEM_TAG_RESERVED_MIN		13
+#define HID_MAIN_ITEM_TAG_RESERVED_MAX		15
 
 /*
  * HID report descriptor main item contents
-- 
2.53.0



