Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9923C425CE5;
	Tue, 31 Mar 2026 16:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975096; cv=none; b=CJlaJUiOp9k6eeaJ2IPUtEIinP3pOK13Nypax0iRMilrmGlBxbB/L5wsyTO30sTUh2MEm3FvMkjfNRtaD8GGOuyRRhlJlbYckdy9DyRBNKGon1vbhMUc1rNDTq0nBEqf9ViLiEY7yltK/H8KagnTiyZhHl+rxj80PBMAeBYSTtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975096; c=relaxed/simple;
	bh=bzU9pXmje8WOI54AwEddBYa2wPbffWA1TgYP7qmhEZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgL8jC8sjvS5pYhfyfLuaE7OwWb3ZBbrJS3damznmEl3NLuGS4G3zjjAa/KsiYscFzWTK9MY6Ef6B9RfFR+o3HNB252EN4aA9edZ6KRR6KAsnyImMOJuPhzZ54sblXufU55Uu21dQ36wszlDf80jgurp+mbOuAsm6Tposp4RybA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+ym7tEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+ym7tEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB0EC19423;
	Tue, 31 Mar 2026 16:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975096;
	bh=bzU9pXmje8WOI54AwEddBYa2wPbffWA1TgYP7qmhEZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+ym7tEwmQxnjqBpTeprGiEzDV0XX/rFe/I89lv7NIAn+eqDEkjf9S1ihwM7lXDIU
	 qoNzPGniObj5s9Wdc50U+qslJTjbMRD1KhxJSfrCHbS20JuZKdRZUaSynV3/Dlnq5N
	 XGOPGWm52J1EnpPiqNLdS7lfXsjA0LkD4hDPp8uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 130/342] rtnetlink: fix leak of SRCU struct in rtnl_link_register
Date: Tue, 31 Mar 2026 18:19:23 +0200
Message-ID: <20260331161803.790814869@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 09474055f2619be9445ba4245e4013741ed01a5e ]

Commit 6b57ff21a310 ("rtnetlink: Protect link_ops by mutex.") swapped
the EEXIST check with the init_srcu_struct, but didn't add cleanup of
the SRCU struct we just allocated in case of error.

Fixes: 6b57ff21a310 ("rtnetlink: Protect link_ops by mutex.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/e77fe499f9a58c547b33b5212b3596dad417cec6.1774025341.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 6cdf6ee8be216..11cdad3972ad8 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -629,6 +629,9 @@ int rtnl_link_register(struct rtnl_link_ops *ops)
 unlock:
 	mutex_unlock(&link_ops_mutex);
 
+	if (err)
+		cleanup_srcu_struct(&ops->srcu);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtnl_link_register);
-- 
2.51.0



