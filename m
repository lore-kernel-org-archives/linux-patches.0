Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E886E444700;
	Thu, 30 Jul 2026 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428232; cv=none; b=kAskdgSUV/0ujdmTyk9/D7iuZn4OHImywuPlkEwcHEAezzP9VmqOyJ8kGjauqZgdyBPUwIm7Sv6HJwHowKHoUqNgh9a/9JTdTAHk6WFoTIq3WyY2HEA02ouqCm9rrn0HkUx5g9BTGD46ySt5/B6YIubm99VdvGsGSVahlNduOkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428232; c=relaxed/simple;
	bh=JY83lYiFLn1Tj/RSnPmsxgR4ijKhFmu0rxwCL0DXhOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z72RYZGjiiRFgMhFxago5NwyQPzB1tQdGts/NPcFmbal1seSDKzg6/8O7rL2QlnurHxt2cVnOCRxdgaYyI5ATJYXOe0+bcg7OTX7eTv45PHMyzdQnxrIdZiYt/x/c44vrgFXRMxwjPcMCPoskdh0bZhFqK7AMjA3vH5PpUp68Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXKiOw1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXKiOw1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2A11F000E9;
	Thu, 30 Jul 2026 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428230;
	bh=BFMZg8QKGO6NK/w303gaABEI3lzE+hyLdAb8NKl23Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXKiOw1n6El0tSb9PGj447tNy6t9DZ5NvJNahhUu2vp8Gs+8+/p7tZ5wnYdjDjV/D
	 GhMNGimOOfliLV6MZzirppOsFp1jMHcVw2OHR/ZDIqEgEXaRnmPjRUEqHBHYFpaOby
	 rESDjlEvv/G3e5vgymrTl/ZDnqZptq3TVJOxhMq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 448/484] dm-verity: avoid double increment of &use_bh_wq_enabled
Date: Thu, 30 Jul 2026 16:15:45 +0200
Message-ID: <20260730141433.214664127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1172,6 +1172,8 @@ static int verity_parse_opt_args(struct
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
+			if (v->use_tasklet)
+				continue;
 			v->use_tasklet = true;
 			static_branch_inc(&use_tasklet_enabled);
 			continue;


