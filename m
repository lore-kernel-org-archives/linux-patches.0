Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C24C46A5F6;
	Tue, 21 Jul 2026 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655880; cv=none; b=ivCfPz7teasqdF1dCOGcQJNKy9SFE2Tg6vK28whjCTJcTt4qfjzOaRVkSPkVtXYkIqiPawW+k33cHg2h0x8gf40i+LO/ePkS00Fg+/KRJUo73c00W3kr/vg+1qvRxNoP7eFelFTHTsKcdu0iUt5Im7RgggoYW78G7fjzk+lVOMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655880; c=relaxed/simple;
	bh=WMBOIypKUAbRSwyF2wkoKIu6x8DUEJsG0PO2tdXfuVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwGoz3DAN291Apf3x+wxjnRiLu1Od3oGb5KFGXsprL0jWS7cxYtWXJb9OMn+/mThCiHKZxUCy7o4GJrHN0bG4xLb/o7fWags03AwpQxlHZFWUpMV0wQebbUlub5EfmEKQy9qtDflXKtFLd9fPgYVP6lHISrhtBXCI3xzps1q9vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSZHpOj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSZHpOj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D264E1F00A3A;
	Tue, 21 Jul 2026 17:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655879;
	bh=DjcbWT5B/I4dtTCwqMrrvcnVOdDrpFCli2H654cCWtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSZHpOj5u3tRRkkEbSpVtyuPsDJRLHDwlkGwErtybPrysLNc0g5MC/8BNno9Sq/PM
	 eNiFjV8QIViKJHML7y6g40FRcG8f/sSDEwyqCYpf+7oQ2XklvDtd/jq/XjFnKYmEr5
	 qADCp9DSeBd3xRjxCpOjfg7egtYVCi7LRJ9tX0EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0175/1611] sysfs: clamp show() return value in sysfs_kf_read()
Date: Tue, 21 Jul 2026 17:04:51 +0200
Message-ID: <20260721152518.842041491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 454257f6d124a92342dcbb7710c03dd6ef96c731 ]

sysfs_kf_seq_show() defends against buggy show() callbacks that return
larger than PAGE_SIZE by clamping the value and printing a warning.
sysfs_kf_read(), the prealloc variant, has no such defense.

The only current in-tree user of __ATTR_PREALLOC is drivers/md/md.c,
whose show() callbacks are well-behaved, so this is hardening against
future drivers doing foolish things and out-of-tree code doing even more
foolish things.

Cc: NeilBrown <neil@brown.name>
Cc: Tejun Heo <tj@kernel.org>
Fixes: 2b75869bba67 ("sysfs/kernfs: allow attributes to request write buffer be pre-allocated.")
Assisted-by: gregkh_clanker_t1000
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026052000-drove-unicycle-d61b@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysfs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3825e780cc580d..b25f6a951c703d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -120,6 +120,10 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
 	len = ops->show(kobj, of->kn->priv, buf);
 	if (len < 0)
 		return len;
+	if (len >= (ssize_t)PAGE_SIZE) {
+		printk("fill_read_buffer: %pS returned bad count\n", ops->show);
+		len = PAGE_SIZE - 1;
+	}
 	if (pos) {
 		if (len <= pos)
 			return 0;
-- 
2.53.0



