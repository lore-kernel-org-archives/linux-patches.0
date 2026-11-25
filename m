Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625170;
	b=ldoyfoOf5D52A1LswF4gqu73QW86zUQZNBGtL7Ss5pKNp6TJ0Jo7YKZeUZsNPigUiyPY
	 HCybGsxoxo6accm9WqDpcisuq/OwS8sHutsO4gUpHL4Cfq6pZoIjQbhg7iD6U/B5xW/aG
	 J3M9U59Qa/OxO16uBU0kRHdy09TaDXW+xqTQMNEgbF18Lq2bxxc5TLegFL7EVgmm5icDW
	 bcqHmmVN+N7d5Xxucw3u+B1zYEUZxFhk7rZaemv7FRjmR4dNwu3YArI7lCSVTfNg8DUKu
	 G1QWl1/Yj3rA8liSy2cW47xMgl334dhZORDoDN/hKBRxmQ5CtqbWTfD2Naj4854KdpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LaDbQRy2lKsBLz/Y03EPRxR9m0e4uWehmAkNsE3EIog=;
	b=3Lij+1y7KYIyVIC4btTPM6LqdWI8JvXl4XeV1wiqNNIbdQ0P/BBSvL5oNLVqlXWjeIkR
	 FQA8PLGY3HXBtkLLD4auuWY9tdNZeiymzZjtoEaq95sNU/0AEOB3vEWeR/4bRjCsLtMX7
	 SfetKfNhzvbLNqNlRck4R3JS7qM6TI1JFpzkqmLYcKeyZArvpPeo/2Yl4oLa9GJPmZHSe
	 8zofTZzsgCdijcvNXbWT+o+INiYuy6VfmXQniBQF01GKOkF9F3fBVellNN9us4BA9oTvL
	 8BpDu8llSzjY/swuwqum/8mYy9slVSICCXTtk16ZdyhCzXdtFK7Hd3mUWtl8OeRu5AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGdPsVsD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DB8606A31E;
	Wed, 25 Nov 2026 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGdPsVsD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB54B1F000D8;
	Wed, 25 Nov 2026 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625170;
	bh=LaDbQRy2lKsBLz/Y03EPRxR9m0e4uWehmAkNsE3EIog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGdPsVsDG2LUJ54mFIvU7LvPJcwMAMPwSV7XOsReUYQ9j25kTnHkpM+k6Gz8RPvLo
	 sragN2UTQI3JucNnrFkBO/38xlIi+ySDJ5J/hhR3x2Kx28GXA4S3R5DcUcvgtIT+if
	 WSPnNevA5lEsm/Dwcs3ecthrkVbew4Yhaii8plz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/816] sysctl: unregister tables before freeing bitmap
Date: Wed, 25 Nov 2026 15:32:58 +0100
Message-ID: <20261125143859.147185971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit 238dfe02fb0a9f72d7fd275d74ce80f13923ef31 ]

The table registered for bitmap_0001 retains a pointer to
test_data.bitmap_0001. unregister_sysctl_table() prevents new handlers
from starting and waits for active handlers to finish.

test_sysctl_exit() currently frees the bitmap before unregistering the
table. A concurrent read during module removal can therefore enter
proc_do_large_bitmap() while the bitmap is freed. KASAN reports a
slab-use-after-free in _find_next_bit().

Unregister all tables before freeing the bitmap so the unregister rundown
provides the required lifetime boundary.

The unmodified module reproduced the use-after-free in three KASAN runs.
With this change, three runs each completed 100 load, read and unload race
rounds without a kernel diagnostic.

Fixes: 2ea622b887e7 ("tools/testing/selftests/sysctl/sysctl.sh: add proc_do_large_bitmap() test case")
Assisted-by: LLM
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_sysctl.c b/lib/test_sysctl.c
index b6696fa1d4262..a043e27287db1 100644
--- a/lib/test_sysctl.c
+++ b/lib/test_sysctl.c
@@ -264,7 +264,6 @@ module_init(test_sysctl_init);
 
 static void __exit test_sysctl_exit(void)
 {
-	kfree(test_data.bitmap_0001);
 	if (sysctl_test_headers.test_h_setup_node)
 		unregister_sysctl_table(sysctl_test_headers.test_h_setup_node);
 	if (sysctl_test_headers.test_h_mnt)
@@ -275,6 +274,7 @@ static void __exit test_sysctl_exit(void)
 		unregister_sysctl_table(sysctl_test_headers.empty);
 	if (sysctl_test_headers.empty_add)
 		unregister_sysctl_table(sysctl_test_headers.empty_add);
+	kfree(test_data.bitmap_0001);
 }
 
 module_exit(test_sysctl_exit);
-- 
2.53.0



