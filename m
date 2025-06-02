Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F612224247;
	Mon,  2 Jun 2025 14:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874009; cv=none; b=B0lQiO4k2vOYG5/v782S95dJJ5mMuZGKVRhlgP1V60xlw+eMyR4eDD0nWWCCdiqR6WrQHGMDuee7zTfjLnVBv8PhxzAjLXTmnxl1R2QVT+RXLH/9tbK4dFR7aXHmWozpXF/SFIBhwd0/bqq2Ud1nnkqOohXLFh3W3hNrALNlloI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874009; c=relaxed/simple;
	bh=19+KWgiUUZl1m8g8K2MuP/aTW4OUPJIN2M5isG3XbCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anzZZM4S67UG/6erQoIRgQlf0AqbEu37yhEQBpH9cmjizqULEMrjTkELpSowdL5/JHzu1iJgGsy+snXIY9grEL6gSRZu31SJgSUM/H1eKMGrNpOvHNUOe4ol17p3Rw34PdsWGhaUfSANnxFxMtAfUvAhENr6lkGYxhQ4QJLYEm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1R+fphjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R+fphjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C122EC4CEEB;
	Mon,  2 Jun 2025 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874009;
	bh=19+KWgiUUZl1m8g8K2MuP/aTW4OUPJIN2M5isG3XbCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1R+fphjomSRvSu584/AbYAJ30tJUnesbQder1ALFmf1oXndR8Uvp+d2i+8u/QKtA/
	 wOndc0dx5tpeI34to8ZKu+GWS09bMlatxTwrI9aOPIxurKbzm9ubK3uLbVTuTOayCK
	 XjCZomNXIlIVdvWrP6K7blkNOlN1G8ZMdge8tL7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 326/444] tools: ynl-gen: validate 0 len strings from kernel
Date: Mon,  2 Jun 2025 15:46:30 +0200
Message-ID: <20250602134354.175450977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Wei <dw@davidwei.uk>

[ Upstream commit 4720f9707c783f642332dee3d56dccaefa850e42 ]

Strings from the kernel are guaranteed to be null terminated and
ynl_attr_validate() checks for this. But it doesn't check if the string
has a len of 0, which would cause problems when trying to access
data[len - 1]. Fix this by checking that len is positive.

Signed-off-by: David Wei <dw@davidwei.uk>
Link: https://patch.msgid.link/20250503043050.861238-1-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index ae61ae5b02bf8..0871f86c6b666 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -368,7 +368,7 @@ int ynl_attr_validate(struct ynl_parse_arg *yarg, const struct nlattr *attr)
 		     "Invalid attribute (binary %s)", policy->name);
 		return -1;
 	case YNL_PT_NUL_STR:
-		if ((!policy->len || len <= policy->len) && !data[len - 1])
+		if (len && (!policy->len || len <= policy->len) && !data[len - 1])
 			break;
 		yerr(yarg->ys, YNL_ERROR_ATTR_INVALID,
 		     "Invalid attribute (string %s)", policy->name);
-- 
2.39.5



