Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690E9377A8A;
	Tue, 21 Jul 2026 22:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672625; cv=none; b=lzUf8awkEMLPYbNabZhwlhLqmr41vslekLtOPW4kPGwwykHWqfCdxoub3AwQtmyU1Rx4yJzLwmFsB8dtW4+lcCs8iOAJfDwFkuytUVVZ17fzFUUo+CaFlKsNddtMA175t0pGnenGAmJoK0LpnkIGgj5jM3Gy2ok0ap9GqtiRn/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672625; c=relaxed/simple;
	bh=nj/slIcfXAIbIjYYXC7f6Gu8ve03/88t9NNl+6kfbm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXEAfLUydZwqiiCNn2mzvfFjQkRrZdTdbuki7syXwFzjSpX+n4HNej5MEbcDLksoj7F8bvwmdZkL5cjYjdQ2s4flehMDg+dfwPJ0FyUmXqvT6J9JXfAh5u9xAUxfP0P7wz+y8DX0ci1yX6w1P8IP//ELRy6shbeJ40Wo+XFHS24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6cfaK2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6cfaK2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF1C1F000E9;
	Tue, 21 Jul 2026 22:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672624;
	bh=j8YvHT4Y6CnaM8OiWgWWuoPS4liwua6lWFR95CkXUJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6cfaK2mCO/LNoM6cbyG2xzUVLUuP3rumFI40ocGfAtONFGHeKR+05yrAFGo4wcEl
	 U4iEm0MUe3xwUcYssu9rblZ2U8CnCjmEQMhFdPx4Ntr1DorKNI/cUQY9W1+GLC21UF
	 kpaloteS3eMOQSwu2TPokDhAg1rmeSGEQ7oNbuvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 696/843] fsl/fman: Free init resources on KeyGen failure in fman_init()
Date: Tue, 21 Jul 2026 17:25:31 +0200
Message-ID: <20260721152421.709299175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d288efa2b94abc2e45a061fceb156b4f4e5b37be upstream.

fman_muram_alloc() allocates initialization resources before
initializing the KeyGen block. If keygen_init() fails, the
function returns -EINVAL directly and leaves those resources
allocated. Free the initialization resources before returning
from the KeyGen failure path.

Fixes: 7472f4f281d0 ("fsl/fman: enable FMan Keygen")
Cc: stable@kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260625004834.3394389-1-haoxiang_li2024@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fman/fman.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -2022,8 +2022,10 @@ static int fman_init(struct fman *fman)
 
 	/* Init KeyGen */
 	fman->keygen = keygen_init(fman->kg_regs);
-	if (!fman->keygen)
+	if (!fman->keygen) {
+		free_init_resources(fman);
 		return -EINVAL;
+	}
 
 	err = enable(fman, cfg);
 	if (err != 0)


