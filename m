Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E133F471CE4;
	Wed, 22 Jul 2026 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738617; cv=none; b=Iq9YxP8sd22pPnrQ/ridhl80z5OaGjNQchR4IygyU6UjMl4TRQvoHRNKjjm3qb+nRs96W8Ikw4J4qtXgnKJ+BYrKS0NRkDEQR9LeC4XQmEsD1kAgY2mT3TysFX230YMy/J8H4GB0CuFE8cqOPTB7hCHrCpCf4QoMoIz0/8z4vtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738617; c=relaxed/simple;
	bh=MPgZudTPXXOc0AvRX0wtlpJwYUjtL2EHOpWMXjtgDKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw/DPZdrLBdbN889Hm2fTplxMYa/PQyTFv1vY+rEoF7uaGG/V6K5ZRsJTv7zDRG+26bq2CA743+zHWf9dtcueJBbYJ0MRn0rBQ4Kp8yw7aQUE1ig7BueDVKC7KiL5U+mpnluenjTZCyfyYoFVYIqmnUq6RXOcHOgtBFT5VehOp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6aTwAEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6aTwAEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349571F00ADE;
	Wed, 22 Jul 2026 16:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784738608;
	bh=+58Zy8mT5F6DnLXXDeqPQlBPm/r4jZVpbWk0iXqLxHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6aTwAECvURJkGJgx9XVljCCFLlsojvdVA14orbmkwGFMzX/SsIpwfpyyyMLRIS0m
	 0h0djMo5jAEyPvfCdr1rsyP0BcguxdQ9azt0PLxjMkbJ/uhZVhE4AWOak4IddVShYi
	 QtS6XZCVfqHJuh+QrIyYG/ATfaLo4gxE4krNRZb/xjTwv4ySwU6o2ROE+/TlDohMjp
	 dlUMqptXnxcmDkAD1a9WfahtIsHXmItF0FFJsR7Nc2LmnYoyMaF+TZyKADYgb8ajKv
	 AN06hrltLZ9qu+8Bx+Gr1/R8jmvQn1EX2JkH8+ajd61W4FajOrD9suJzmIAbSStaNp
	 4khpgpw0X9Eww==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 159/349] fs/ntfs3: zero-fill folios beyond i_valid in ntfs_read_folio()
Date: Wed, 22 Jul 2026 12:43:17 -0400
Message-ID: <20260722113507.rc-reply-0007@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <7a338426-7b4c-485b-a177-9b3651e3c716@oracle.com>
References: <20260716133033.287196923@linuxfoundation.org> <20260716133036.938913374@linuxfoundation.org> <7a338426-7b4c-485b-a177-9b3651e3c716@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jul 20, 2026 at 12:22:10AM +0530, Harshit Mogalapalli wrote:
> It preserves the new zero-fill fast path but drops the bad-inode rejection
> that precedes the same path upstream.

Correct, and the omission is intentional (see the [ sashal: ... ] note
in the backport): is_bad_ni()/ni_bad were introduced by 519b078998ce,
which is in neither 6.12.y nor 6.6.y. The guard is new hardening that
upstream added together with that infrastructure - the pre-patch
ntfs_read_folio() in these trees had no bad-inode check at all, so the
backport doesn't remove any existing protection. A bad inode reaching
read_folio behaves no worse than before the patch (make_bad_inode()
already swaps i_op/i_fop, so the normal open/read paths return -EIO
earlier).

> The narrow 6.12.y adaptation would be:
>
>          if (unlikely(is_bad_inode(inode))) {
>                  folio_unlock(folio);
>                  return -EIO;
>          }

That would work, but it would be a hunk with no upstream counterpart,
which we try hard to avoid in stable backports. If the guard is wanted
in stable, the clean path would be backporting 519b078998ce itself (or
a dedicated upstream follow-up). Note the same adaptation already
shipped in 6.12.96 with no reported issues.

Keeping the 6.6 patch as queued - it's also a prerequisite of
d7ea8495fd30 ("fs/ntfs3: fix missing run load for vcn0 in
attr_data_get_block_locked()").

-- 
Thanks,
Sasha
