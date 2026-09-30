Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739883BD22C;
	Wed, 30 Sep 2026 19:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796489; cv=none; b=VAEL+KYNp5fx1YZqjLn0xAWgDr3yMoXRsf9sNaQqbpZGgRkIqC/W9RU42I7ISoQVBpER+KBaoGcv8LVwifFbvAhfZEIOSfynq1893NLkwAhYMLwZWJzaNx5MzGQwIm2w3t5qAur6TMZKGjns8n80gtYHQFwatv66O/LBjbmM5T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796489; c=relaxed/simple;
	bh=zeckEr2OS6YNQ7VUCsAfreOZWwISgla0CzyNmyy7iVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3NOM/LQM/EZEADwg1rGQVxrdOyYToqIdj2LdeqYpxpsxFow1tFgTmMya7cvSg9CtVnpbQzqLf0jMR9E0mcGjUJKL784xsrynwQfOX8/eyb2HJUd9SFlEj3eX6Di8pB91QX35Rd5Y+aXRVDB8VzDN4pfuuVwtueQxxNkiHo0nZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcIL89+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcIL89+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806201F000FF;
	Wed, 30 Sep 2026 19:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796488;
	bh=mB3n9FZj83gvcAl3qWSMs8/H0GMPnMmMAEY531r/1aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcIL89+tQhPEOcbbKY3Hp2dgn24EUcNmTnUNd6vgne1wTrmfWRLFAgGaY03edLKD5
	 29xh4dwYVmeTqu8BABpyV2GfwHZTBpaHCACXFCp9TGsIG6zi4TOUoJV0cNyuf/l78b
	 SCvWxGYDQDDUhp+W7UDFzxywFZN8CZmzqihOpsEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.6 0930/1193] drm/gud: fix out-of-bounds write in gud_plane_atomic_check()
Date: Wed, 30 Sep 2026 17:26:54 +0200
Message-ID: <20260930152454.903286460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sajal Gupta <sajal2005gupta@gmail.com>

commit 59ced288fcba9e91bd38e61a972ad782c4edb7d0 upstream.

The plane property loop uses req->properties[num_properties + i] as write
index while simultaneously incrementing `num_properties` inside the loop.
At iteration i, num_properties has also incremented by i, so the write
is done at `initial_num_properties + 2*i`, skipping every other index and
advancing by 2 per iteration.

With just 2 connector and 32 plane properties the last write happens at
index 64, one slot past the end of the 64-slot (indices 0–63)
allocation. A USB device can trigger OOB by advertising the maximum
number of properties.

Fix by dropping the redundant `+ i`; num_properties is already the correct
running index, as gud_connector_fill_properties() fills the preceding
slots.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260821071812.16500-1-sajal2005gupta%40gmail.com?part=1
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
Cc: <stable@vger.kernel.org>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260902123254.36987-1-sajal2005gupta@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_pipe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -538,8 +538,8 @@ int gud_pipe_check(struct drm_simple_dis
 			goto out;
 		}
 
-		req->properties[num_properties + i].prop = cpu_to_le16(prop);
-		req->properties[num_properties + i].val = cpu_to_le64(val);
+		req->properties[num_properties].prop = cpu_to_le16(prop);
+		req->properties[num_properties].val = cpu_to_le64(val);
 		num_properties++;
 	}
 


