Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DA553B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B84C433D9;
	Sun, 17 Sep 2023 19:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979129;
	bh=jBHwWXo5SZAQQY+7r3JeTvPQt3Q/6p0Hr/TTu/NmUqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1J4HYC0BtkJk54bxdUPvNJKWG61XxEsYwKuVvd51tHmdAg18Eyl6zEZWFS7rAykQ
	 1ZBrhAyZaX4Yv0eVLdfmjt35/1jyBxo8V/DJazqNMWKR3W70PTpktmEW1HgHiD0Kvr
	 vheDdxEvuZ8Q5nE7prHhMLq5+eLnrhplxTLk/E4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/406] fs: lockd: avoid possible wrong NULL parameter
Date: Sun, 17 Sep 2023 21:10:51 +0200
Message-ID: <20230917191106.397241002@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit de8d38cf44bac43e83bad28357ba84784c412752 ]

clang's static analysis warning: fs/lockd/mon.c: line 293, column 2:
Null pointer passed as 2nd argument to memory copy function.

Assuming 'hostname' is NULL and calling 'nsm_create_handle()', this will
pass NULL as 2nd argument to memory copy function 'memcpy()'. So return
NULL if 'hostname' is invalid.

Fixes: 77a3ef33e2de ("NSM: More clean up of nsm_get_handle()")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/mon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 1d9488cf05348..87a0f207df0b9 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -276,6 +276,9 @@ static struct nsm_handle *nsm_create_handle(const struct sockaddr *sap,
 {
 	struct nsm_handle *new;
 
+	if (!hostname)
+		return NULL;
+
 	new = kzalloc(sizeof(*new) + hostname_len + 1, GFP_KERNEL);
 	if (unlikely(new == NULL))
 		return NULL;
-- 
2.40.1



