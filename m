Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBF91B4257;
	Sun,  2 Aug 2026 03:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785640559; cv=none; b=Hdz52pl+h1RmYLreNPiTnfUcvbvTJtC/EvRQWBz4X1ikk0boRHdiqlssPWwowQW6KnlsLQjVC7cthQ3EqD5vZ0+oG5malgOLEkgWiIXzu9EA45oRobDqhVW0Tz2cVVOOaCwIREQRBHhIm1wHv9Kaqgkr46u8bP7vSlPFURWBzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785640559; c=relaxed/simple;
	bh=IarNcg7eqTwLTIqWUBlQCvbuRhTWnZBOgCcqZTYTLcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsF83iHDvuYvWTx9mYGW0W281KrC7fuGTO0ax5XfBEA8nfxetCFBddA0b0VrZU+sqJ95LXNt3js3aG3P6S1UTW56LBEdv5q86tplKph5kBohsZyy3gNu7eTDaMm0tGbYsntEmwomNkbu7q6tfM6O95FGSrHKM3VCVwGcx3mswks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hffbv6FN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hffbv6FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40481F00AC4;
	Sun,  2 Aug 2026 03:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785640558;
	bh=QhHaR5Gu+z2ilrrsKVqwy/Nvr4826aLpuqywLMDCAoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hffbv6FNTmTglpm9jG3FMomNBsDHFjipxtvvYom4AlQPFS/o2osyxDb0Ve9o0KrY0
	 mWF0qu11Zf81NL5FyWo/xlpyvLS0Yz52fvWcy3yqd3Lmtsw6YtTQsOwqKwA/rm/neh
	 hg52YZxMv8qtnuI9IrJCT8Q+jCxK5VAjEkgetEZ/Pe/xO6rBWmLdewoywA494WBqlq
	 h7PmADLM0zHnMWU6sK/Qw85hh+AO+w8b2/rqhT2D99JClbOe4JZPfMbS+Ffp8IiPjD
	 Fe3+Evs43/gzao3gi1kB3IT2EjsjuHVmJb/ov4ilD5JTNX7UumiRaNUzicYP+CEHld
	 4nmb0oaYWUFYg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 528/602] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Sat,  1 Aug 2026 23:15:51 -0400
Message-ID: <20260802030150.2c5d2d3c3f70@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2eae07c3-848e-4bc8-a444-f8274692f653@oracle.com>
References: <20260730141435.976815864@linuxfoundation.org> <20260730141447.107046386@linuxfoundation.org> <2eae07c3-848e-4bc8-a444-f8274692f653@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, Aug 01, 2026 at 08:56:42PM +0530, Harshit Mogalapalli wrote:
>I have run an AI assisted backport review and it spotted an issue. I
>have taken a look, and this backport does not contain the fix described
>by upstream 2c5d2d3c3f70.

You're right, and thanks for the careful review.

>The 6.12.y commit still has:
>
>     if (xd)
>             queue_delayed_work(xd->tb->wq,
>                                &xd->properties_changed_work, ...);
>
>and no removing field or guarded request-handler queue sites. Its diff
>only relocates the unchanged update_xdomain() function, so work can
>still be queued after cancellation and run after the xdomain is freed.

Yup :(

Dropped from the 7.1, 6.18, 6.12 and 6.6 queues, along with the full
prerequisite chain that came with it:

  - thunderbolt: Keep XDomain reference during the lifetime of a service
  - thunderbolt: Remove service debugfs entries during unregister
  - thunderbolt: Remove XDomain from the bus without holding tb->lock
  - thunderbolt: Handle lane bonding of Gen 4 XDomain links properly (6.6)
  - thunderbolt: Remove usage of the deprecated ida_simple_xx() API (6.6)
  - thunderbolt: Update property.c function documentation (6.6)

The actual upstream commit applies cleanly to all four branches, so I'll
requeue it properly next cycle.

-- 
Thanks,
Sasha
