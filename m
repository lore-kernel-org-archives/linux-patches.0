Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23133451AA;
	Thu, 20 Aug 2026 04:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787199579; cv=none; b=p+e0Y58IlRfl12MJNrP6HbP71caAJcN6W3RO15y3DZta6SDOyjwomf2htAyZMR8xqPu8ca/kFBAMWptSKjolvaCsSgjG72SfrJzRzZe1wxlU4T20bXGoFZHFxOfdKyr5MoOQ/KIX//Q5P9ccpexVriWRSo25IidrEhmFqyPvXiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787199579; c=relaxed/simple;
	bh=Y6m0SMcLAKlofMjMcK1S9pibrVY7da6tSISThzs076A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzmesiMDJD5Y4nXXfRncXunTgKAsI5hJkINdQSZVmkhWJKlVs/chjeLCglYexkyfgHSg50WnZfR8WQQnkbwd7TGZ4nNwln9+/WJ+VeVQLV/hXZODh1bWN1+nCg9/hsrq0bfA+cgpFNkiEZ/Do9EPvZxlxki2CjU70RevZFlcacc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPrZXDNO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPrZXDNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5106F1F00A3A;
	Thu, 20 Aug 2026 04:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787199577;
	bh=PS7RY+u0BmSKq1YYBO1INrN6NW3CXJ0joTGHsRj54cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPrZXDNOPwvabFFHigzF9JFWbirxgsT6DeKTG8tWhShNEj+a1Pmanx+61voP1Gywj
	 2UVLI3BRKu8CK0VQS00taHhjlr0vTvRrfi9zFK4gPgivp6RYGj5CqTPMXGRIMFWK0a
	 vvjJgfZ+evaKC2UZjfdkhYmghe+5lod4nSZMueTHyY6uOzG4oQPbXe/dn2MMF4HTw3
	 dO9uH+mtjMjgi6ZPqHrC2RboCMR0VPCY8eMGj1wZnRKBZtMP9zWNlGmESQUk+eue4Z
	 eYUSYNFnRqwKjLTc6YTvRzZ57MOCTAm4qxGUOPmOIO+dTATJvD2TLZlX/BejUyvqbX
	 yx0vwOlhESEvw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	liam.merwick@oracle.com,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 111/181] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Thu, 20 Aug 2026 00:19:27 -0400
Message-ID: <20260820040907.6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <521b22fa-ef09-4449-909f-0120edfc4b24@oracle.com>
References: <521b22fa-ef09-4449-909f-0120edfc4b24@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Aug 19, 2026 at 12:41:48PM +0530, Harshit Mogalapalli wrote:
> The relevant upstream commits are:
> 
> 435b344a7042 ("crypto: ccp: Add external API interface for PSP module 
> initialization")
> 44e70718df4f ("KVM: SVM: Ensure PSP module is initialized if KVM module 
> is built-in")
> 409f45387c93 ("x86/sev: Fix broken SNP support with KVM module built-in")

The finding is correct, thanks for digging into it. Queued the first two
for 6.12 - they go in as a unit, since the second is the only caller of
the helper the first adds, and the tree would not link with just one.

The third is a separable pre-existing fix rather than a prerequisite: the
RMP-init ordering has been wrong on 6.12 for CONFIG_KVM_AMD=y since the
SNP host support landed, independent of either backport, and it conflicts
on this tree. Backports are welcome :)

-- 
Thanks,
Sasha
