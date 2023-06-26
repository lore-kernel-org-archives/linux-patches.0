Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA07B11CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252F6C433C0;
	Mon, 26 Jun 2023 18:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804796;
	bh=CB4iqS6QBcYygSMa7xFiPxzdOjqSf8Ej75ndeu28NR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HW2XB5m0aK5GsK3BRDJSyS8sxcFu87lW/4Pl/ov9fH/DB33PigvpHZKtCLt4yiCGF
	 WI5vhfEXxhZ/Johk7E7TsyQihf13C9hlN3MU3PEP561UEbgT6BgnQVeYhFBFM5VOPu
	 c7fZNKxd/2yn/erUU4oEvhNqe0WoChGjRmVNKJ0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Marc-Andr Lureau <marcandre.lureau@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/96] memfd: check for non-NULL file_seals in memfd_create() syscall
Date: Mon, 26 Jun 2023 20:11:52 +0200
Message-ID: <20230626180748.493707567@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
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
index 475d095dd7f53..a73af8be9c285 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -330,7 +330,8 @@ SYSCALL_DEFINE2(memfd_create,
 
 	if (flags & MFD_ALLOW_SEALING) {
 		file_seals = memfd_file_seals_ptr(file);
-		*file_seals &= ~F_SEAL_SEAL;
+		if (file_seals)
+			*file_seals &= ~F_SEAL_SEAL;
 	}
 
 	fd_install(fd, file);
-- 
2.39.2



