Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063305;
	b=cXW+zwaN0iZNdzCWjKB01MSBPefGsoJZnG1wvcuKUqUooJdFIw7qmE2W2WfFFNK7S0Ez
	 DLfWlNCZmsthgTfYTfNPtf6Cq0+T8r0ib/NXZURF5G8xp9J5bjwSWwcUU+KFRQZy0dOtq
	 YxLk2dmipTr9H1GySqz+yRsiJJqJurnV/PLc88ucU9usmZESXWxAYsuPxsexPRi+arsFN
	 ngG3Njnj2Hn/0B9I+IvL7sG6wy7wf1F1iUSD86HwyjfTEe9X4cVWCQGn1ZhsL/6YUGCIg
	 cwB3z7YJ77scJcj+bxav7bw10V/MDB4a91A5UKe3KCBsG4nG6QPzrFRwBwY/Ey77jUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jpnGQjLj7+OZvTObVUykEv/rCT4SeNDpwQoOZtYnw3w=;
	b=CSIjAMdL8dR8pt4NC8xpnK28h+gKbJw3pBrtt+9u3Ig6OcC8eOxXYnA2bgyq9Cxueuwr
	 KvrUmoKMMIFrG0iyzuKO6sUHBLArs0ZSBjUwaOe9CFvIseflbXI44iQoa4svZH6+qppFi
	 oksmJ6xl9mmXtjYN3LWA80YkhyKt7XDKTQEx72ewQt8XqL9yTtNUkHgyR19HBAF1Mvp4Y
	 rVpwfzdLojAXCbqzjhYZQciEPpnwu33yKQPEG3xd3AO39qUDY4a/n4CnrxRURu5Zw/zHP
	 bgMTN1t1ZUwj/o5k2kAkZezh7b0dLlYhL7BjPe1I8XDZkdGnJn9kLByKGJm1R9yQ3iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAgqnfrI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52F3606A334;
	Sat,  7 Nov 2026 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAgqnfrI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7301B1F008A1;
	Sat,  7 Nov 2026 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063304;
	bh=jpnGQjLj7+OZvTObVUykEv/rCT4SeNDpwQoOZtYnw3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAgqnfrIboe+6+8QwA60/40SjPulUzkp3tZhBKEflUlkQKRd1HKMlE8ZNmY0NAhyX
	 FJSrIwIUy43QEghW/NpsLrsnPX+WHb7jgNr+lbbwWZ8E1tvb9+JexxKgX3a7SrSHmc
	 rAxQn1PSKa1UB7MA1feh77w2drFZJFO7r8rUf2ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Boykin <jtboykin.jb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 494/869] platform/x86/amd/pmf: Fix power_supply refcount leak in amd_pmf_get_battery_prop()
Date: Sat,  7 Nov 2026 08:52:56 -0500
Message-ID: <20261107134910.293349949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Boykin <jtboykin.jb@gmail.com>

[ Upstream commit 9f3eebbbd1033de0abcc2694ba4b455d30fe33f9 ]

power_supply_get_by_name() takes a reference that is only dropped on
the error path. On success it leaks, five times per policy evaluation.
Unregistering the battery later trips the use_cnt WARN_ON in
power_supply_unregister() and never frees it.

While here, return -ENODEV instead of an uninitialised 'value' when
no battery matches, and stop at the first supply found rather than
letting the last one in the table win.

Found by reading the code. Fix and changelog drafted with Claude Code
(Fable 5.1) and reviewed by hand. Compile-tested only (allmodconfig,
W=1, sparse); not run on Smart PC hardware.

Fixes: f4627dfd0e19 ("platform/x86/amd/pmf: Add support to get inputs from other subsystems")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse
Signed-off-by: Jack Boykin <jtboykin.jb@gmail.com>
Link: https://patch.msgid.link/20260902210217.69483-1-jtboykin.jb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/spc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/spc.c b/drivers/platform/x86/amd/pmf/spc.c
index 85192c7536b80..cbe4eef5b8bb4 100644
--- a/drivers/platform/x86/amd/pmf/spc.c
+++ b/drivers/platform/x86/amd/pmf/spc.c
@@ -244,13 +244,11 @@ static int amd_pmf_get_battery_prop(enum power_supply_property prop)
 			continue;
 
 		ret = power_supply_get_property(psy, prop, &value);
-		if (ret) {
-			power_supply_put(psy);
-			return ret;
-		}
+		power_supply_put(psy);
+		return ret ? ret : value.intval;
 	}
 
-	return value.intval;
+	return -ENODEV;
 }
 
 static int amd_pmf_get_battery_info(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in)
-- 
2.53.0



