Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACE43C1D66;
	Wed, 30 Sep 2026 19:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796809; cv=none; b=KXIkbFAsenEvXpCWzDH+WPDU1mPlAxF5eOz6SyBgEjqNsQsgzErTvXq1ZxCjaQjVCYxgLJ1QubQo4/pUK+/epBa4pZx0sESDx92Rz+qIAZ5PYzIaPEok/H5sSJt/lMxrlwL52RfHN1aOiqcpJCwElVpM/onXwLRpXW6PkvyOTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796809; c=relaxed/simple;
	bh=xJCbvSnnILCwOTkiFC4SRZNGYWEezY6oAr7grb1ADik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgdI4PYhTEuGPt2Rjexez873C8VQlCi6ZhA1cqOxL0Qngswj98a5/W9yxXRjU/kvnM3ZzXM8A2HJi0w8FB2Hj95a3rNapJHEU7nIjU74Z5lopSY6ANx6gB8aD1qxfEFVEERKtIhexGWu+hCa9l6QwsZpMoWG81evLe3fzUqRtIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jETqnSBf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jETqnSBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059211F000FF;
	Wed, 30 Sep 2026 19:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796808;
	bh=G2kfQ0R3PA6g3WMJwasKp96K99kr/U/ETGia5lAbmQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jETqnSBfNEFxKSlTUmAr0FJYc3pbQ41W9mBw/0o9TrDGZ9YGcwMqY7hEGR7Noy3TT
	 OYniIxEmPvepWm7IurGT3deqNvHzPu+OK3LclgHQWF1Ig21WkA7psqFfHt0q6s1whV
	 6lLTshI3MX71x6Vsqec0g44M7DMSXYMivBPLzpPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1042/1193] selftests: nci: Fix uninitialized family ID on missing attribute
Date: Wed, 30 Sep 2026 17:28:46 +0200
Message-ID: <20260930152457.371751763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit eda518d2cdb6074a0bcdfa06af291616bcb5c421 ]

get_family_id() walks the generic netlink CTRL_CMD_GETFAMILY reply
looking for the CTRL_ATTR_FAMILY_ID attribute and returns the parsed
value in the local variable "id". If the reply does not carry that
attribute, the parsing loop never assigns "id" and the function returns
an indeterminate stack value, which the caller stores in self->fid and
uses for subsequent netlink requests.

Initialize "id" to 0 so a missing attribute yields a deterministic
(invalid) family ID instead of a garbage value.

Fixes: f595cf1242f3 ("selftests: Add nci suite")
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260901070618.3299012-1-nagachaithanya9911@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 2fae9ea352c87..2a96ca0a9fb1b 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -182,7 +182,7 @@ static int get_family_id(int sd, __u32 pid, __u32 *event_group)
 	} ans;
 	struct nlattr *na;
 	int resp_len;
-	__u16 id;
+	__u16 id = 0;
 	int len;
 	int rc;
 
-- 
2.53.0



