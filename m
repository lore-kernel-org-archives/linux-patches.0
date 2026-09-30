Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1905374A16;
	Wed, 30 Sep 2026 16:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786536; cv=none; b=mJJeMQoHpGgHOANytcUDViP9W0N9gwwHnAekluogG+VNjVT1J8ggHr+gmLPypKrg+akzH4efYu/aNgBdGRht/D1mskNnztWgpULGBxzu+wuKJg1INdhUR1eW1L3PyVseOoXIydGs+SfJ/Nq2XYCSXP0N5iGRPgccXDmD5VXxtVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786536; c=relaxed/simple;
	bh=ukWlX6zqiDgQBf3NCAidxxTiQ6ghLvUKMJMPrwETtAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFLuYoYNQRNT9H3tJb7sa5Kp/TZoKA2vlZUESuqmgKsHX69BWsq/RCnD/S0zEwyMHPNZgT/X6CuUZjhMahSLGKsEytBW4Y16FLQXmcJC239Y1qzHkHVIkRZNCcWqE0Zng8E2gnpHI0+S8TC4wHICFzEZBDgF+wZARJ3X7bAQE7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DF9GXtuy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DF9GXtuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2384B1F000FF;
	Wed, 30 Sep 2026 16:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786534;
	bh=by7PykH+v67y8PmycJpbesPGfiKG1U56Qr/ICGVSNos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DF9GXtuyUd25Omz0oArIN61dk8Bi+EiR3DbDrmO8gbKE+d/aMnygVhpyZyi+aN8kz
	 lpSy1EFEBXxy8IwfqgnSNgwowd0xEoOHt6F707rvLaoMT8mwe9WQqVJ1QI9midAfO0
	 81RMJ9kC5yR3hQu/UP8Ydl8jyq9Mjiws/kYbOleM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 879/982] selftests: nci: Fix uninitialized family ID on missing attribute
Date: Wed, 30 Sep 2026 17:26:55 +0200
Message-ID: <20260930152435.630332746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6f571e3c21c09..87262f8d0c101 100644
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



