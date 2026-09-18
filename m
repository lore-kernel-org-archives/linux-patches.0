Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6CB50B8DC;
	Fri, 18 Sep 2026 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746855; cv=none; b=gdJJZXn6mVN1J1JOtDNbJVmwJE0jxcguEgKOmMhgsSGV6NSiHAMISyKLmf3mU4ESMyy3RsPW7ODEqhELVJSamQbL5S/1an9b28WekscTm80h8jjSGNJ/fTx8Dnkv/u+AqRzeGXEHdS9lqUqB/faEWdVPHXnTBchh8ktTtV20kWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746855; c=relaxed/simple;
	bh=gizjOLNO7p3fkn5KhEpxbFmH7YV/glWqfh5W5hVhTuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebJaw4YAFpJnGIVPrI0A1EyqFizVrkm6yCEDOvehJtdq7HrOyiCCBSgfio607bUOj2CmgbiIALR1wVzaZ4pbPy5UzV1l8FmypiIzdMawkALMdxVxCRjOz6VR0eENVdDpCeUM82JA0DEo/cfODQIQn1OrsJ9nyK535UhotlvM3Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvJ05ect; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvJ05ect"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B924C1F00899;
	Fri, 18 Sep 2026 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746853;
	bh=jzZyR2opvhg/Uisj+jtHQQdTUCKbVRbCE+wjZ5A5TP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvJ05ecto1t06MSKZtLbey4Kpyu5wczps7vqBRXBnli9r2Sdqck6iVRHbFwyQUlR4
	 851973NA0P37rU38lWaGF7r5vKSi1JDDeC2lUL4JNOF5o/RzLhwxXHfBTXAh1Fy0AC
	 jYyrTxuddUB7c+P9BjFtTGC/YPQDuMbO8jvZgTNXzMPhU94bYX5Ojw77RAC3eKdx1L
	 H4Y/zv4tldllfT7zh2mc24bEG9c/u55QdmXtkwOf0+swLXWW+hoRntW4P5mxy9GsLW
	 Eg6oC7N43vM4hJEG2fKphrLUX6oCgQG5WFFMug4UunJfsUa7wukQDcEEze7wEZmNb5
	 xjb7SUVoqbmmA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Fri, 18 Sep 2026 11:54:03 -0400
Message-ID: <20260918151136.2101477301-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqxBBu5GXVhHcqTz@auntie.librecast.net>
References: <20260917151539.408551884@linuxfoundation.org> <aqxBBu5GXVhHcqTz@auntie.librecast.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Sep 17, 2026 at 07:35:34PM +0000, Brett A C Sheffield wrote:
> 6.12.111-rc1 hangs on boot on this machine (AMD Ryzen 9 9950X).
[...]
> # first 'bad' commit: [22ae428b0045981bd19f8c75f700a67198062f32]
> mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier

Thanks for the bisect, it lands exactly on the problem. Dropped from the
6.12 queue:

  b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage
                 struct pages earlier")

For the record, why it breaks only on 6.12: the backport moves
gather_bootmem_prealloc() out of hugetlb_init() (a subsys_initcall) into
page_alloc_init_late(), which runs well before do_basic_setup().  Upstream that
reordering is safe because since v6.15 the per-node huge_boot_pages[] list
heads are initialized unconditionally and very early in
hugetlb_bootmem_alloc(). 6.12 has neither that function nor the commits that
added it, so the only INIT_LIST_HEAD() of those lists is the lazy loop in
hugetlb_hstate_alloc_pages(), reached early only when a gigantic hugepage is
requested on the command line. Boot a CONFIG_HUGETLB_PAGE=y kernel without
hugepagesz=/hugepages= and the relocated code walks an all-zero list head, so
the first iteration dereferences NULL.

Nothing else in the queue depended on it, so it comes out on its own.

-- 
Thanks,
Sasha
