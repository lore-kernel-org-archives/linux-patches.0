Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DE938D3F8;
	Thu, 20 Aug 2026 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248176; cv=none; b=cnbkBx2jC/zxmGvV6n6PrBmMINSzCiZS8Wi8PiIxV/t3qvX/bTfYJfsqANUTBLOqpl7Lckw3CkjIZs+Uc8TiSFEarU/oULDKPWAStedq2dienG+5ibsNmlRfF93e8R7mlUsWv8uJOQSPD/2hkp7YekcaL1BVGpdUL3Job1UXI7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248176; c=relaxed/simple;
	bh=bpjnIkF5R6OfDSUlSOKdXw96CJbs3NIrdX6VBzYiOCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvs9crHi2+l6j78AV3mx/tGoJ9WT6ti5pRsatx5vOIYdnMhqzEgJKyCy86n7WjrddBarQHmUCfu8VDzXmXyREcS58KYqxcI7vQGgWrDYfva21jFgtJN95jArXnjgBUO9BAbuXozlvWgCY+Tr0d8OuRkzQSnJYuW0zZ6sOrME4mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4XP+km2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4XP+km2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F01A1F000E9;
	Thu, 20 Aug 2026 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248175;
	bh=hzk6CDARvt9IXxND7+Qgz7svXblczb5TbAjMpPyayMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4XP+km2Vt84RuMR3W7NE6UmbG6cy+YlfSs29KuuDmwyGOdD7GumcYRVG7OoqbAf6
	 scPfxGL/UkZaThCoftcAFBS5ZU2e8IF/0x875mleipb4hxpq3mVsG+rvdEVRsfzs68
	 aJ2w2IhaSlko4NjMG35Wz/3GRoGYdnXKsld6FRIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/303] dm-verity: avoid double increment of &use_bh_wq_enabled
Date: Thu, 20 Aug 2026 16:54:31 +0200
Message-ID: <20260820145257.330783853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 72e9ec2fe32b00994f41719cf77423fca67d48b2 ]

verity_parse_opt_args is called twice, first with the only_modifier_opts,
first with only_modifier_opts == true and then with only_modifier_opts ==
false. Thus, the static branch &use_bh_wq_enabled was incremented twice
and the destructor verity_dtr would only decrement it once.

Fix tihs bug by only incrementing it on the first call, on the second
call, when v->use_bh_wq is true, do nothing.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: df326e7a0699 ("dm verity: allow optional args to alter primary args handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1151,6 +1151,8 @@ static int verity_parse_opt_args(struct
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
+			if (v->use_tasklet)
+				continue;
 			v->use_tasklet = true;
 			static_branch_inc(&use_tasklet_enabled);
 			continue;


