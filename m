Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A4943E088;
	Sun, 20 Sep 2026 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789926658; cv=none; b=liESr1laBpwlN8J7zWBMU/MYdO7nJh/Qf7moA4XAyFZsQTHfTGFtWYF96PPHWA7POy/IXlVBJLUz4OBrT7v69kb8NsUF2HgTSAOJQxQHBreVj/TR0K8oLczYlEycUN57Zo1pz1jBb7iHCSekb/PrdjgswB7FWImcLSgik+xtHbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789926658; c=relaxed/simple;
	bh=HbYtF0A4wbGwM5fItb1K3YXB85hsGs45ulqhzr++Lno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGo5HL57fYQSCFPWlQb+Qhtja0rfItm1t6D4DWN8b4LaoJdoXT728Tho/DAHUbEPP/rk1vPtuAd/9k5EL0Q0hWqTfi/kW3jN8ygsVG/QLLZ+jT/jfigtvRkopGzvbCLt1te94N3kF1bNRlbh6TsiqmpC7FMpshQZhqk0b1tGFzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdCgI/m9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdCgI/m9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84B21F00899;
	Sun, 20 Sep 2026 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789926657;
	bh=cluXeMow7B6uvJtuWvCsoEGicox6skDcgSKjtPLIDz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JdCgI/m9eTVAp6QRggX6PUOzVQ+Bf9bkaZoiaj78GWtv+7jDevzE+WKGe4X4wwMWI
	 XS77EEE8qL4TqsWNZsylb9e4HKZTEGdbRNG85VXaHYJ3FU/BkJlpELvIYpiVZ98fSB
	 mMMfwzkVhY7XqmuJiBg65NTDL8Y8O1utiKp2M2VVDw9tEOUXeynibxN6qsMZfaWr4/
	 zOgZrffhGZnxBG91gnjrsRAdnEy8lyZzlTJ7/wmbGUPztUDR5bp1mXVGkETAGn5mjm
	 FsyZQlKdqMtMC41rcNSLItfmCS5GxYxI8fRrrTbCvOFlkEvc4gGXpJbxjhluuLZXS1
	 NADxcGh2l8bxg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Ben Hutchings <benh@debian.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 6.1 0705/1191] perf cs-etm: Flush thread stacks after decoder reset
Date: Sun, 20 Sep 2026 13:50:39 -0400
Message-ID: <2026-09-20-daily-reply-0007-re-perf-cs-etm-build-break@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aq-D15YcGtltATrG@eldamar.lan>
References: <aq-D15YcGtltATrG@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> util/cs-etm.c: In function 'cs_etm__flush_all_stack':
> util/cs-etm.c:1656:14: error: variable 'pid_fmt' has initializer but incomplete type
>  1656 |         enum cs_etm_pid_fmt pid_fmt = cs_etm__get_pid_fmt(etmq);
>
> Not sure if 5414b532611b ("perf cs-etm: Make PID format accessible
> from struct cs_etm_auxtrace") would be suitable for backporting.

It is not. That is where the enum and the one-argument cs_etm__get_pid_fmt()
come from, and it conflicts on 6.1 and 5.15. 5.10 has no cs_etm__get_pid_fmt()
at all.

So both cs-etm commits come back out of 6.1, 5.15 and 5.10 instead.  Reverting
the dependency alone conflicts; taking it out together with ec99be8a31db ("perf
cs-etm: Avoid truncating AUX buffer sizes to int") restores the pre-series
cs-etm.c exactly. 6.6 and newer keep both.

They shipped in v6.1.188, v5.15.221 and v5.10.270, so the perf build is fixed
there as of the next release. Thanks for the report; the build gate never
compiles tools/perf, so this would not have been caught here.

-- 
Thanks,
Sasha
