Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC33520DD51;
	Mon,  4 May 2026 13:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903053; cv=none; b=P1Fv+lKrWH9fxuJgBIfwAGSuXJKv3lyIi8mSiXwr4oNGqulC+tQnyi7p7eC49jpA1cY29gCQ/E+YnaB/DPUPlVtTjq9ABOQgkZLvMXt9LNeoIpU1piZz65gDtl8L9J04OYh0fB99fuR7yssDwlgJjOdv8pSCTmxAO54Oq5mZ/rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903053; c=relaxed/simple;
	bh=Vbu57Ae8Mk8Su7QopPyRrjDBYytu7ZwwLL1VPl5LwAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfUQnGu+gbC4N5qUWuhHjltJmfq7ckD/EGJkZ4QKrrFhlN6mBIgKh5gTFjR+B311UOBYVoparg3gHDy7E4ZoOwuEoOjsWXmiJNm7S3kJgSHQJ+DbB+5oC9Bc990bafa77ZjBFBPenj7DwpQ3l4LFpE4fHiNt03Wg++OPzTRsEew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9aguzbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9aguzbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60990C2BCB8;
	Mon,  4 May 2026 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903053;
	bh=Vbu57Ae8Mk8Su7QopPyRrjDBYytu7ZwwLL1VPl5LwAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9aguzbUbN95T48jDufBLqDUnZF/9T+Rg9To7ZrrwgTtWck4eCEZh0aePnHG/XVZ0
	 cq/tppyxAy3OLqbdotqjRG9tHoQfo39Gze3uJB7TnrH5HN3ZJOFF1duSe+JqRtWSyE
	 JBynRHqB8hcuR2DaaCNjf4x0edGO/uWf4UegGc6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.0 085/307] mtd: docg3: fix use-after-free in docg3_release()
Date: Mon,  4 May 2026 15:49:30 +0200
Message-ID: <20260504135146.009625747@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Kim <james010kim@gmail.com>

commit ca19808bc6fac7e29420d8508df569b346b3e339 upstream.

In docg3_release(), the docg3 pointer is obtained from
cascade->floors[0]->priv before the loop that calls
doc_release_device() on each floor. doc_release_device() frees the
docg3 struct via kfree(docg3) at line 1881. After the loop,
docg3->cascade->bch dereferences the already-freed pointer.

Fix this by accessing cascade->bch directly, which is equivalent
since docg3->cascade points back to the same cascade struct, and
is already available as a local variable. This also removes the
now-unused docg3 local variable.

Fixes: c8ae3f744ddc ("lib/bch: Rework a little bit the exported function names")
Cc: stable@vger.kernel.org
Signed-off-by: James Kim <james010kim@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/docg3.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -2049,7 +2049,6 @@ err_probe:
 static void docg3_release(struct platform_device *pdev)
 {
 	struct docg3_cascade *cascade = platform_get_drvdata(pdev);
-	struct docg3 *docg3 = cascade->floors[0]->priv;
 	int floor;
 
 	doc_unregister_sysfs(pdev, cascade);
@@ -2057,7 +2056,7 @@ static void docg3_release(struct platfor
 		if (cascade->floors[floor])
 			doc_release_device(cascade->floors[floor]);
 
-	bch_free(docg3->cascade->bch);
+	bch_free(cascade->bch);
 }
 
 #ifdef CONFIG_OF


