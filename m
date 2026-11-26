Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704700;
	b=ogMyJXP53YZb60VA4TWEHyCI1AypQugB8msJuOSFxJl+GuSsDx0NNXeAHllNexk9VOos
	 YUkDaHFndWHn7s4ZQtF1ra+m/Swp1LuoCRoR4/ospdI2QKTL9NFy2fjOz4pOsgckHUNhZ
	 fqzPBVmzZYa4pB4x/P67i6t02ln82KpYpM8PtlBIhvaGZSz2GZSTXELEQVHN8apdtyJmo
	 WX6GrPrPdkxRURcNf0wUvg0RIYVlxV6v9DpG+Cwvph77HsSgMzXyIW6jo4wqBK3fRbjsA
	 GnKp6LlIJd40Ksxho4dFqiErQrk+novck1ctEarMQm6i7bFAu7/m7PRmO0bm0LnfDxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Z+jSC2nMkl7sloWahA8skrRUyjvKR3ndPeI5jZzw2E=;
	b=CTVxUz7EI26X+h10K35yjW17U1+kIMq/FM065DJnkuO4QaNbONg7A+86d6NsiMMsXcPC
	 0s2Db6aqgdfGkHLy2RhFu2MOAWBou4f1XARBbE/BF74eLaVkVihBNIZLb1m+PgT6bgDac
	 /DA+hXCfpj9BfsXKWby4O1unH6qES2NFQorvxll2+G+1m+Kb/qttkGP55t0+X+2R0/8k5
	 F+nFkP0IB7eLek9JQ4o3t3OT+WKOX9BFtLLNXMQS/cI0rU/63Li6wlDe08cjR372aZp3g
	 cymypws06nxw8/v4bZgpB8mOeAgnyH63ujQ6w+ee70KLCVOC7ObA5LMjwaaiuIYrw7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fCn+x99D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6525D606A31C;
	Thu, 26 Nov 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fCn+x99D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77601F000C0;
	Thu, 26 Nov 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704700;
	bh=1Z+jSC2nMkl7sloWahA8skrRUyjvKR3ndPeI5jZzw2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCn+x99D4PZ8inCXiuS3Uoi5dNyYhqZZRBXTOaNyLeL+sdG1OrNDCIf5DHuU/gAWq
	 n/jm0+Hicg0i+Xq3zK+/A4i2C8nvPwS6Bh+UseduZEVtn/cVVv42WG7z32Fd5IqHYW
	 Y7CEAjiT/DygDlM9mZ7wiTwSU2aNgKtNLLpC8iYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 214/265] dm-thin: fix parsing of feature arguments
Date: Thu, 26 Nov 2026 15:39:04 +0100
Message-ID: <20261126143620.191987721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c557fa19a83efad1e20eb733df821b745a4589ff upstream.

"struct dm_arg _args" limits the number of arguments to 4, but there are
5 possible arguments that can be specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 787a996cb251 ("dm thin: add error_if_no_space feature")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3141,7 +3141,7 @@ static int parse_pool_features(struct dm
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
-		{0, 4, "Invalid number of pool feature arguments"},
+		{0, 5, "Invalid number of pool feature arguments"},
 	};
 
 	/*


