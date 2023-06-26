Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5294D14A8C
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67C1C433C0;
	Mon, 26 Jun 2023 18:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804262;
	bh=u1JjxdzQLojSgdKqg6LD1W1egvWlWQYgVBHv7T0xZsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewThv28S1F58rifg+9lotzg15IBloRupdo5Y7h0aLepqCRRp9vm7WaYPbCq8qFBPJ
	 7ERTw808CxD0STPanK4qKZutn5MrI4LQdE2xA4yhFc5FOfepGSfe9qOr+EhInEYAbE
	 JFYnHMmmR6USWB7FTpnylzD4H3nUqKPz30z9Eaog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Marc-Andr Lureau <marcandre.lureau@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/170] memfd: check for non-NULL file_seals in memfd_create() syscall
Date: Mon, 26 Jun 2023 20:10:48 +0200
Message-ID: <20230626180804.159880487@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit 935d44acf621aa0688fef8312dec3e5940f38f4e ]

Ensure that file_seals is non-NULL before using it in the memfd_create()
syscall.  One situation in which memfd_file_seals_ptr() could return a
NULL pointer when CONFIG_SHMEM=n, oopsing the kernel.

Link: https://lkml.kernel.org/r/20230607132427.2867435-1-roberto.sassu@huaweicloud.com
Fixes: 47b9012ecdc7 ("shmem: add sealing support to hugetlb-backed memfd")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Marc-Andr Lureau <marcandre.lureau@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index 08f5f8304746f..b0104b49bf82c 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -328,7 +328,8 @@ SYSCALL_DEFINE2(memfd_create,
 
 	if (flags & MFD_ALLOW_SEALING) {
 		file_seals = memfd_file_seals_ptr(file);
-		*file_seals &= ~F_SEAL_SEAL;
+		if (file_seals)
+			*file_seals &= ~F_SEAL_SEAL;
 	}
 
 	fd_install(fd, file);
-- 
2.39.2



