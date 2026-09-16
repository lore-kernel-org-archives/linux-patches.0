Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0836B41D129;
	Wed, 16 Sep 2026 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586949; cv=none; b=FAJvXk4mV8kzW7lJiUh+mCMHDJdWsrAiz3mgZP/BmtpjID5wrqKg3TiWXmbtFoHereS/L1jnQ432T4dOwaAPbRTDMZIJtdTLRUNKVsJxA3XjitEMBLXsDl/A4EFFclKLhwTilVl4jpJpif2HaEfybQeHXYxBjXlulLxVJpK2lKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586949; c=relaxed/simple;
	bh=3QMdCruY7nFbl+Sriw2MbssXCHk80EOyRNYbpeHfpac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqy4XyEWVkSEcHUGI+U2en80up2EOiEm3VuzfybQ6gwpvh+57A3DWda7M7fal/bS5mderRm8OIeK750xkn4R9dlniSxqy7HLf90ZsFH4JjPPR7HnSJD9wC6fSeG940fUbKKljouw4A86epFbwgMJ1H7X9o5BanlG0ZjuEFFEoEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U79OlvRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U79OlvRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A251F008A5;
	Wed, 16 Sep 2026 19:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586930;
	bh=w6KY2kDh+4HqI97nEVfw8q/1l1QCRGVLh16qpzJUqtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U79OlvRgvKE/pyCmLcSJ+M9k5tDQdDPNgk9DcCHZr5D/fI5PcOy6UVcliWfP52aVw
	 j3aHWVbWEEH8LCwZMCeQiY+ncCN4HSJCrW3VUGj2PwNgyob3CSFMioGnZY/GXut412
	 SyjtavlbLVQE/dD+fhvb9aW99KwfavspkFBSpv51eYoTBkqUlCe+AkjZklCa/XONKy
	 mQeJ+C65z3PZHaDIa6Fs2X3zsq6yKs492NswzqnXtUgjL5FK/zO2zuirhfT6z6lSDa
	 U8R8/MpxdchyndayZOC6tWXNB0DdlPjBnVnErW7N/5PN0Qf9FYzK+nLAUUGNBh8/2l
	 /ZLhfxM8fCDrg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1266/1376] arm64: Enable ARCH_HAS_NONLEAF_PMD_YOUNG
Date: Wed, 16 Sep 2026 15:28:10 -0400
Message-ID: <daily-reply-20260916-0020-re-arm64-nonleaf-pmd-young@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2820554a-987a-4583-a2c8-b97434eeb697@oracle.com>
References: <2820554a-987a-4583-a2c8-b97434eeb697@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The patch selects ARCH_HAS_NONLEAF_PMD_YOUNG only under ARM64_HAFT and
> maps the hardware predicate to system_supports_haft(), but neither
> symbol is defined on this branch. The capability is therefore
> permanently disabled.

That is right, and it is why the commit is inert on 6.12. With ARM64_HAFT
undefined the select never fires, and the detection and MMU setup from
efe72541355d ("arm64: Add support for FEAT_HAFT") is absent, so the guarded
code never compiles.

It came in as a dependency walker false positive off a Kconfig context line
next to "select ARCH_HAS_PTDUMP" in the hunk taken for 902caade3cfd ("arm64:
ptdump: Make note_page_flush() range aware"), not as a real prerequisite.

It is already released and has no observable effect, so I am keeping it
rather than adding a revert.

-- 
Thanks,
Sasha
