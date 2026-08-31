Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A1F34F483;
	Mon, 31 Aug 2026 01:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140378; cv=none; b=fWU1UJSukAtP2dDJ4upYiXQ0OilMzdRFWBIQZ9YenjPvcISXsAkjhI/4uE3zE98F6wAxRM7PiqMn8oUzcH0KLKCuAmtsEhPCnX3xsUjJtGy1GPRmPsCukG2xchqelzG+UEYsZqv/LqudyzkwWlaUK1s4rQPSQ/QSmuxR/G5CgKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140378; c=relaxed/simple;
	bh=jFCJmJphwCc5NzMnPA7F9c61t+KSyPDAcnJuL7u4h88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W34gfrRrL3+Aq9gagBZWPGlLRhaOXbNCM6z+sHRDD9igWVo2U41XCdu/eMNZ2GVOFR53xKLZcSEgAcmQDwnRE1Gkt5tGtLf1jmO2xhxaddH2A0qdEpD7S4A4E+SSYuxERLvrFnusPkxiEegAIJxf+XyW+XdgBQXM6z9zyvEQPgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAy3HiYB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAy3HiYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55601F000E9;
	Mon, 31 Aug 2026 01:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140376;
	bh=USfqzfAIag6mug/fRgthuutwsPpoAaosbBWO2RP22+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAy3HiYBDacNn6ukKARs3duiioX+8p8qyK4IqgNnEU4wNhMAw2v1QlkePznElnoHD
	 RbNK2bO4+0TNSxW3AggWx/1bwb5UiPLacOVTxvu6UlwXtqLcOtej7YvGXiykhJwUDR
	 34SBzJjltEYfX30A1FN+c1egwUUMF60B+ES2DgKCa+8TPjKZ6+MvWQlM/Zd0CAO9pX
	 BKzmsBlAwdGAOQxiPpm7TcRx/+cNJSjSdpt8W0S1jpAtrjNh25i2gM8PknJh3SzHo1
	 fhb0LtC/SsEEqW3XsfZhB2RFXd/1ftLkuPtTWMU7GD18MBBTNMFhdv175R3vO4Zq+g
	 +Mq/fGI4c2zgg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 134/220] smb/server: fix minimum SMB1 PDU size
Date: Sun, 30 Aug 2026 21:39:18 -0400
Message-ID: <20260830195700.0013-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8734a305-5f47-49fc-9bc0-3fde57ab23f2@oracle.com>
References: <8734a305-5f47-49fc-9bc0-3fde57ab23f2@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream has an RFC1002-free struct smb_hdr which is 33 bytes, so:
>
>         #define SMB1_MIN_SUPPORTED_PDU_SIZE \
>                 (sizeof(struct smb_hdr) + 2)
>
> correctly includes the two-byte ByteCount and produces a 35-byte minimu

You're right that smb_hdr still carries the 4-byte RFC1002 length on
6.18 and older, so the minimum there is 35, not 39.

It's over-rejection rather than under-rejection though, and no real
client sends a NEGOTIATE that small - a single dialect string already
puts it past 47 bytes. Leaving the five trees as they are.

-- 
Thanks,
Sasha
