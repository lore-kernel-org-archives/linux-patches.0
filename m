Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF2B358389;
	Fri, 21 Aug 2026 16:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787331099; cv=none; b=OPTMEi22tftcNkH8NzWVBavFIZ76M9kVm4ywlOtFY3WfxXYjTU2LXUzT0vf33/KcHMBkx2nYY/25cDDSMBD35hPyR7NSRtV82+NyBKxWnxqUaR0oahkmRBYertjKWuR9fVUx/EZlKTf+IUi0f6c4rZBxFO81s4o83FUo/3vPstY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787331099; c=relaxed/simple;
	bh=8i0+iayn1ff/hcvqpicQXQW034U6CBPSK4X3gL2DQQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhYdhChR/wfcQ9L9glg8B8kNiVOkdJn6MObws9rFJIaSPnBa4DLH6531Bf5spMG7Wir52XYfzSCi8/ApXntFU7KPUpf+nq4WkESW3XrfbuvX9ns/loRKu0O7mpq5K4VmXXK0ACHrrp9WZXgHiOsTO4QMmHd9oJG8bmxjN7Ep7/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bV0TukEZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bV0TukEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0921F01563;
	Fri, 21 Aug 2026 16:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787331095;
	bh=BR5zYiNJdXr6C2m+J2G1H7O6xxMqbyOxUq+18dZg24c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bV0TukEZP52QSFc9DvBOiNABjgsyZF1ROEYwu8fK5NqRO2722oVh/Vul+0lb+ak7t
	 vcnMI+soWDvo3dz3179bBYqh7O4srm08Ga95YwR2VMx7VJJ4GBlKNCcISAvcl967SR
	 7Fo4sbe5YCS9UbgEudwyAGVrBH25WKMO/G+1b8Ge+a1O+g7DQdgrkecgY8OWiPoePp
	 92vGX2IE5l+C0EYNo1CUwDzOW/sxJEDcZ9WG+ZcHSK1YnJHU8wQRCLu/2Z3fo3G0aU
	 oHTcPWXgRforv4gCugIizwZLbfpUYwUvM6Q7Bhm3d228TRRHr8rQFQEWZ+yupvkVtI
	 En7chIlaulvNw==
From: Sasha Levin <sashal@kernel.org>
To: Miguel Gazquez <miguel.gazquez@bootlin.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.12 189/220] ipv4: start using dst_dev_rcu()
Date: Fri, 21 Aug 2026 12:51:31 -0400
Message-ID: <20260821152000.rc-ipv4-dst-dev-rcu@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9342b269-9362-49ba-b9c8-a0df9ff1102e@bootlin.com>
References: <20260820145223.480031205@linuxfoundation.org> <20260820145229.195230707@linuxfoundation.org> <9342b269-9362-49ba-b9c8-a0df9ff1102e@bootlin.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Aug 21, 2026 at 11:45:50AM +0200, Miguel Gazquez wrote:
> > +	dev = skb->dev ? : skb_dst_dev_rcu(skb);
> > +	vif = l3mdev_master_ifindex_rcu(dev);
>
> Here, the upstream version has a `rcu_read_lock();` that I think should
> be added. I will send an updated version.

Agreed, and confirmed here. Upstream that hunk lands after the
rcu_read_lock() introduced by ca0359df45a5 ("inet: frags: save a pair of
atomic operations in reassembly", v6.15), which isn't in 6.12 - so as
backported, ip_defrag() reaches skb_dst_dev_rcu() -> dst_dev_rcu() ->
rcu_dereference() with no RCU read-side critical section of its own,
where the pre-patch 6.12 code used skb_dst_dev() -> READ_ONCE() and had
no such requirement.

In practice every in-tree ip_defrag() caller already runs under RCU
(netfilter hooks or the NAPI receive path), so this is a lockdep /
correctness defect rather than a guaranteed CONFIG_PROVE_RCU splat, but
it does defeat the point of the conversion.

Dropped from the 6.12 queue, thanks - please do send the v2.

-- 
Thanks,
Sasha
