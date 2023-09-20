Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BDA15AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4E9C433C7;
	Wed, 20 Sep 2023 12:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212128;
	bh=s7IIMGTK21Rt4jDSGGzPGXwp3vsRutxOIhKOXSrbbUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGbcAQso7H0/yOZenSdDbNaSZV+CyEmCz9Sbb/A3l9b2YvvnEVOKCy1OHgvezDlg1
	 N8jEd7BsPHQi7vPmE6zSjcQhbvctPSbGXvNyah4KJuLbur5nXpF8X/aRRdaIw9Yr89
	 i47zukWaH+YutFP1SopPeW/4tJSM8O0i68a66kBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 127/273] fs: lockd: avoid possible wrong NULL parameter
Date: Wed, 20 Sep 2023 13:29:27 +0200
Message-ID: <20230920112850.427604383@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 654594ef4f945..68a2eac548c3c 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -275,6 +275,9 @@ static struct nsm_handle *nsm_create_handle(const struct sockaddr *sap,
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



