Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7580A33CA;
	Mon, 28 Apr 2025 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745840766; cv=none; b=b/3k3JLg682nDPX+bjflp42BhTkmbH8gCuvx60dLYKmkw8I+fxwrsd52YDuoBIr+SMep2NZVdbnzJejq/RXqj7sXvgc2GpFcWPsj9SUrbar/NDB8V6o+5djwWQPi3qVS4ZPX429valSRXFIPwdeNH5Wmw1AFjI/w7w0d9QOEct4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745840766; c=relaxed/simple;
	bh=8nXbkoT2v2qPt+AQWQ9rzZpX7NPO3n+1r/ylvmv4B2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rD9u9v2NMb9a8ntyc3zbNNgSRss1D1utbuJ++AtXgzweHRT30eOia7Ora2Zatqqx7PJ9C0dZwbwfsiuvikL6x9mmTW5VV5G8FE3rhPuOw123Q9Nx6ISHAaPNAxj5vfXVj5zPTyB/RIqWeFC26apojKVibfMyKZ7WHAnYqsXNDGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIvgq28X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIvgq28X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE15C4CEE4;
	Mon, 28 Apr 2025 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745840765;
	bh=8nXbkoT2v2qPt+AQWQ9rzZpX7NPO3n+1r/ylvmv4B2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OIvgq28XQFZ1kxzJMb4jP6qgbysirPdTYLl2XOnQx7oc45lKYHmuIgwk1Rl3wr2cX
	 VfQ3L5icgrg3Zi2Gw+MZoAMtQ/HqDYYrFr9rwOB25HJTpbu2Zx9nwXbeYNTQD88ol7
	 MdrYnFh77iG76KxeKNxsphkaxgW5+4jWWnxZwxsE=
Date: Mon, 28 Apr 2025 13:46:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, jhs@mojatatu.com,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	michal.swiatkowski@linux.intel.com, zhe.he@windriver.com
Subject: Re: [PATCH 6.1.y v2] net/sched: act_mirred: don't override retval if
 we already lost the skb
Message-ID: <2025042844-pavestone-fringe-1478@gregkh>
References: <20250428080103.4158144-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428080103.4158144-1-jianqi.ren.cn@windriver.com>

On Mon, Apr 28, 2025 at 04:01:03PM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 166c2c8a6a4dc2e4ceba9e10cfe81c3e469e3210 ]
> 
> If we're redirecting the skb, and haven't called tcf_mirred_forward(),
> yet, we need to tell the core to drop the skb by setting the retcode
> to SHOT. If we have called tcf_mirred_forward(), however, the skb
> is out of our hands and returning SHOT will lead to UaF.
> 
> Move the retval override to the error path which actually need it.
> 
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Fixes: e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [Minor conflict resolved due to code context change.]
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
> v2: Fix the following issue
> net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used
> uninitialized whenever 'if' condition is true
> found by the following tuxmake
> (https://lore.kernel.org/stable/CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueUa9H1Ub=JO-k2g@mail.gmail.com/)
> Verified the build test by cmd(tuxmake --runtime podman --target-arch arm
>  --toolchain clang-20 --kconfig allmodconfig LLVM=1 LLVM_IAS=1)

I see 2 "v2" patches here, both different, so I'm dropping both of them
:(

