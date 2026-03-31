Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA3A2FF669;
	Tue, 31 Mar 2026 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976503; cv=none; b=ePMWVDN0eAHu8586N5O1NYRNofed3mSzsvAvYb7rLLK/RQBm30rEmD79r8cHp+GruT9mcdDpiS2Pun46aaTS7rmarhziUwoS8jxMY3xFHXzuChBItl78U3qG2BpjhN6F41vfg/ZQtRA7RfcQ3KO8dpTPhW/90EqC9lXdEgDHiwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976503; c=relaxed/simple;
	bh=mszdTCObfEterdgmR7YXI9tBW7uMKuAynaLlCT3YOgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dm6V8ExQ0VUJSj334iDtdLM+pkvePOJfYQ2VMvnp1qnMYjA6+t6wEw/LghAddBizb0OyNb8P+r2lAkDnUxcH1hZR9z5H5c7qPI3iP/EzVqkHm6TaJ3REM0gAidxO7YVu9pPZTFgv43Gp1qCAwxlDx7hMqemu60IMrNyAK5ykM5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3G9hqLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3G9hqLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2467C2BCB1;
	Tue, 31 Mar 2026 17:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976503;
	bh=mszdTCObfEterdgmR7YXI9tBW7uMKuAynaLlCT3YOgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3G9hqLwlm5gfjPh1e+7KIzdf26dcrBX57hf0v6EI/CrgeC0vW647EGSej6D0UThT
	 j9D251A2xHwMW/KlxiRxL3akoQPqm06/5cpiZiXwf7nsB0lkEKYsteI+tLLla+jEKi
	 /apMeR1B6XpIXTuFA3zkAO1AoMFRUFs68JG5P+O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/309] rtnetlink: fix leak of SRCU struct in rtnl_link_register
Date: Tue, 31 Mar 2026 18:20:20 +0200
Message-ID: <20260331161757.790176122@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index b389210d518ef..f3b22d5526fe6 100644
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



