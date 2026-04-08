Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8545B3D75C9;
	Wed,  8 Apr 2026 18:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673999; cv=none; b=rAkwv2rMqL4mpMGLI+YL2rSdEB3XgT4VNUW4+EqVok9UhnQurKY7kPg29RnuG9Qd11DyGQKZWrX7ofLoUi2DRIiuUUGczXGUArut5GrRWr6zJrk8sMOV4ESwsUGIGmR0UVTISPqnEvhx+zWcdUO2ahMWc7DUbMhJi1cwGrDyDNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673999; c=relaxed/simple;
	bh=nklmQERV2K0dIAX71x/1btzCN33oP25F8pvJwf+tTzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZffmLoDpYaVNRH3gHZkdBXzTN++HgOn2j9E2MIYoWjrZFBgeX1OELD3pFA+IaxFcrI0jReRhtyTh1OnOoLLy/sowD+HhGC9yJKFwzycpGaY01J4ewb8exbCIAw4AmNRjZkq8dXy1hV/o+vlxTqac6xWHodhgd7jh7+raVhbJYmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiBql+Qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiBql+Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9EBC19421;
	Wed,  8 Apr 2026 18:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673999;
	bh=nklmQERV2K0dIAX71x/1btzCN33oP25F8pvJwf+tTzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiBql+QsiwbomNjwz0ufVsxy869cfinhWs3ewCA6JxqYByYREZkUHhNyqnKqifq6O
	 AJX5bCRDmiSgZZeXOuaEjnSMnhPqbv3+r+dYYMyYRFjhEusRD0QetZs/ZlNo4qiHoR
	 djxaeoVZXTk98P/8iDgw8CeiA0VRj3hEMUxGPd8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/242] Revert "LoongArch: Remove unnecessary checks for ORC unwinder"
Date: Wed,  8 Apr 2026 20:03:29 +0200
Message-ID: <20260408175933.413297553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 5d8e3b81aee2c18610c5f440936f0bf3b6426e56.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_orc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
index 4924d1ecc4579..59809c3406c03 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -359,6 +359,12 @@ static inline unsigned long bt_address(unsigned long ra)
 {
 	extern unsigned long eentry;
 
+	if (__kernel_text_address(ra))
+		return ra;
+
+	if (__module_text_address(ra))
+		return ra;
+
 	if (ra >= eentry && ra < eentry +  EXCCODE_INT_END * VECSIZE) {
 		unsigned long func;
 		unsigned long type = (ra - eentry) / VECSIZE;
@@ -376,13 +382,10 @@ static inline unsigned long bt_address(unsigned long ra)
 			break;
 		}
 
-		ra = func + offset;
+		return func + offset;
 	}
 
-	if (__kernel_text_address(ra))
-		return ra;
-
-	return 0;
+	return ra;
 }
 
 bool unwind_next_frame(struct unwind_state *state)
@@ -508,6 +511,9 @@ bool unwind_next_frame(struct unwind_state *state)
 		goto err;
 	}
 
+	if (!__kernel_text_address(state->pc))
+		goto err;
+
 	return true;
 
 err:
-- 
2.53.0



