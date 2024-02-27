Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D11F13F006;
	Tue, 27 Feb 2024 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041435; cv=none; b=u+aPUlchUaTtww1LSMv7qBAh8l1n28bf8pjoRuOm18bse1ckgeD8ytcOLZMxI3jfCt/PuVKVsC88Gj4pWCcIOmJLR6ufI/adCevDUG18/uDxV6wsPUzRUUVvGcwklM4UVAPaHXYfgUh+0YCKpPTmLuLtGKRUTqEih8FFjijLqBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041435; c=relaxed/simple;
	bh=37hzgksObGXAsE5Ub6K5IP40By2z6xlr1Y5MUCu7ilg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uT95Tt909B/piGkc+3P6IQb26Pm5gyHxvhUFHrGv1mMnZ3I7mj3N3pMwMoPaB8OGp3HxaVf1czk6PIVakeNcpbacGKlClmRH2Myes8Aw4xJHMb+PlpcQxT2R4vQvhUiTRimFfOP2CxQpE2mnrnTIm9BFLUoZ6YT+4ag9FEZBlTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrQHv+1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrQHv+1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD68C433C7;
	Tue, 27 Feb 2024 13:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041435;
	bh=37hzgksObGXAsE5Ub6K5IP40By2z6xlr1Y5MUCu7ilg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrQHv+1seeeGHmKMwYQzpnM8CRGxgyLDNPF2rQTTpcYd6CaUglNeh1cPfGCtwN0mW
	 0xVKvvkXAfzOr7s58IXQFv43PdVGYn0AbpdbPQK5supbOrPqWsS2MhKCa0tBD3S7gt
	 vKrepcdLDVDMhFjkN19KYejd0R0ddp3hdt/p3/lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 313/334] tools: ynl: dont leak mcast_groups on init error
Date: Tue, 27 Feb 2024 14:22:51 +0100
Message-ID: <20240227131641.170280273@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5d78b73e851455d525a064f3b042b29fdc0c1a4a ]

Make sure to free the already-parsed mcast_groups if
we don't get an ack from the kernel when reading family info.
This is part of the ynl_sock_create() error path, so we won't
get a call to ynl_sock_destroy() to free them later.

Fixes: 86878f14d71a ("tools: ynl: user space helpers")
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20240220161112.2735195-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index 65975a8306738..591f5f50ddaab 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -584,7 +584,13 @@ static int ynl_sock_read_family(struct ynl_sock *ys, const char *family_name)
 		return err;
 	}
 
-	return ynl_recv_ack(ys, err);
+	err = ynl_recv_ack(ys, err);
+	if (err < 0) {
+		free(ys->mcast_groups);
+		return err;
+	}
+
+	return 0;
 }
 
 struct ynl_sock *
-- 
2.43.0



