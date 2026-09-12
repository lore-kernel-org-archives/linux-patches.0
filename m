Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2CE34252D;
	Sat, 12 Sep 2026 09:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206388; cv=none; b=q0aGuQ2ZFXKh+1nqMo6k39QiqYyKNtfs7OC9SPfyFLhmzyWBBa7yTSeP63zeZoqQlimjAxZW6LE8ShKOKAjQ1FZycHdJWTEK19YwcN1+Tlal2qU3Ub0VgkBaxNh/oCrdljlJ1fSZLJPEkwVf+5OwAKh4D7BnStz8nPhnG8r6cvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206388; c=relaxed/simple;
	bh=J+rHD3mgWX2qCV62L6GVV1Tw/LadIeZN6CSOdzyluDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpERgrLxEsVAKzLA7vrOzy3bNPe+5u63ZtSnEM+jq/VE4Y+m+jEwyF2isBk2X1TwGyYSc+p2KgDsp+BuiQM1qBRbCOwNgvGZ4PgBIel8lxDTQcp8W8ZnX3KVQm16YUP3K5KQOmAjdb6LvPlBnM87PIs/clSxIRl/VBrGxZpvdw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loWxGHc1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loWxGHc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F42351F000FF;
	Sat, 12 Sep 2026 09:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206387;
	bh=j66nRoD9bLHy/+fj35axIgamzS+E6SxVt/SKZiY9qFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loWxGHc10fRlq0IKyUDQ983Rc/qfzXWp0PA7QN3x+no4o4g+oCTOke31sx09cTijg
	 MxvSPlMV/LLERLGqpY6NF7c2cf31MOa7jb5iVMsfM9XQpCxmWCYszdT5KTMmnYgkgJ
	 /dDUZNad4LIbM6uPUz400MrfWsQqcrbsVU9Lh/n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manos Pitsidianakis <manos@pitsidianak.is>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0198/1518] hwrng: core - fix rng list on registration error
Date: Sat, 12 Sep 2026 08:39:27 +0200
Message-ID: <20260912065627.968900801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manos Pitsidianakis <manos@pitsidianak.is>

[ Upstream commit 3a5834db2b1ce25649f330e78efe1ccde78967fd ]

hwrng_register(rng) does the following:

1. Checks if rng has name and read methods set
2. Checks if the name already exists
3. Adds rng to global rng_list
4. May try to set rng to current_rng

If step 4 fails, it returns an error. However, it does not remove the
rng from rng_list, causing a dangling reference which can result in
use-after-free if the caller frees rng, since registration failed.

Add a list_del_init() cleanup step.

Fixes: 2bbb6983887f ("hwrng: use rng source with best quality")
Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 036de7294bbda..054ffbc9e4220 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -604,11 +604,13 @@ int hwrng_register(struct hwrng *rng)
 			 */
 			err = set_current_rng(rng);
 			if (err)
-				goto out_unlock;
+				goto out_list_del;
 		}
 	}
 	mutex_unlock(&rng_mutex);
 	return 0;
+out_list_del:
+	list_del_init(&rng->list);
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
-- 
2.53.0



