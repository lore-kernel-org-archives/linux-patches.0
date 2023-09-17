Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D267461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1666C433C7;
	Sun, 17 Sep 2023 19:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980110;
	bh=IFK0CWamUz1bH+HfxUv1NDI9JlSix+HSjGjtywd7gtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQ11yP43nXSfzm0Wt2Jic4uCETRDBTRglg6VuO9r9xx/aE36xFJjCxNmgOvb+uC9d
	 iRlptCgTn61If3w14Y8pCm74jPt5jJ7RLhJ86RuaGLsZbOxl0F2L0tveeT/5wQZwDb
	 G36N21hMS03jVio27663/VOTprQkbroxzHcdzi1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Subject: [PATCH 6.5 063/285] kconfig: fix possible buffer overflow
Date: Sun, 17 Sep 2023 21:11:03 +0200
Message-ID: <20230917191053.890593865@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit a3b7039bb2b22fcd2ad20d59c00ed4e606ce3754 ]

Buffer 'new_argv' is accessed without bound check after accessing with
bound check via 'new_argc' index.

Fixes: e298f3b49def ("kconfig: add built-in function support")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/preprocess.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kconfig/preprocess.c b/scripts/kconfig/preprocess.c
index 748da578b418c..d1f5bcff4b62d 100644
--- a/scripts/kconfig/preprocess.c
+++ b/scripts/kconfig/preprocess.c
@@ -396,6 +396,9 @@ static char *eval_clause(const char *str, size_t len, int argc, char *argv[])
 
 		p++;
 	}
+
+	if (new_argc >= FUNCTION_MAX_ARGS)
+		pperror("too many function arguments");
 	new_argv[new_argc++] = prev;
 
 	/*
-- 
2.40.1



