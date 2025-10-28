Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E0134D4DC;
	Tue, 28 Oct 2025 17:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673809; cv=none; b=AKdIt2IRcS5fngRgCaC1mKVnrK/LJpGJgRHDzFD/y4YKzboVltPFUQh7W+PrxNggQHp674Xb02t2/0vx40sFuWvf54P5bKdKxa4KhmI/gf4hghog0fwjCIlq6dg7VjSYqiJlGVR8BhSsMxpO0U+hDKz/E4qwGSBTu7+Qh5N4jWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673809; c=relaxed/simple;
	bh=0q+GiUYteQ/lQcoyJq1MnhmPR0PcR/6dgD1yyVtppHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jNhfJ58nFgq0wyKx6k5H9E/kuYCoyE8SwB9F0ZT9YuZvnz3rZq4xDcYcPqK+03txHN2D/sARcMpEVzkTqKivOM01hk22ztgJsDDAP8q363Ai2HKHdlJy72FAjxRvhp3QYaZ88QyZGD9QUdCTgPT3f0EWEdV4k2KZux6uJFmOxts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLltaceA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLltaceA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA299C116B1;
	Tue, 28 Oct 2025 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761673807;
	bh=0q+GiUYteQ/lQcoyJq1MnhmPR0PcR/6dgD1yyVtppHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oLltaceA7lEcpAxzatPfQ96dAELBrsU5GeltW3VUGVClDFzmi2dOJJp5mNCBEzKOo
	 0s783wSUuq7FE19ndIRuIR+G1GMsGdkGi77BYLvtEfrZon5xbwP5jMWGWCxWBE9qnT
	 27gQmEtdYvLZ7JcvgedbReXxGrR7ptlMuapUVECV8+P8V+dJe0aE+rU6rhwmPf2Wsd
	 /R9yPZ/hWtSr13a/xiMxA3g3DHYu+pGIUmSW4EJwKQ2pb/Gr7X34/MPE38r4y1Ltqg
	 0Pr97i9tthwKGf/2Xp02CjHX9G3IzeJ6qEKEHFCCNWEWXMjhdxcuJJM+3gDqYfRYHM
	 0l5/+TMCZhQ1A==
Date: Tue, 28 Oct 2025 13:50:06 -0400
From: Sasha Levin <sashal@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Ramu R <ramu.r@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	przemyslaw.kitszel@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH AUTOSEL 6.17] idpf: link NAPIs to queues
Message-ID: <aQECTnYEi8q7wycn@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-238-sashal@kernel.org>
 <e81c5f0c-eaf5-457e-8257-eaf0e7116164@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e81c5f0c-eaf5-457e-8257-eaf0e7116164@intel.com>

On Mon, Oct 27, 2025 at 04:19:24PM +0100, Alexander Lobakin wrote:
>From: Sasha Levin <sashal@kernel.org>
>Date: Sat, 25 Oct 2025 11:57:49 -0400
>
>> From: Alexander Lobakin <aleksander.lobakin@intel.com>
>>
>> [ Upstream commit bd74a86bc75d35adefbebcec7c3a743d02c06230 ]
>>
>> Add the missing linking of NAPIs to netdev queues when enabling
>> interrupt vectors in order to support NAPI configuration and
>> interfaces requiring get_rx_queue()->napi to be set (like XSk
>> busy polling).
>>
>> As currently, idpf_vport_{start,stop}() is called from several flows
>> with inconsistent RTNL locking, we need to synchronize them to avoid
>> runtime assertions. Notably:
>>
>> * idpf_{open,stop}() -- regular NDOs, RTNL is always taken;
>> * idpf_initiate_soft_reset() -- usually called under RTNL;
>> * idpf_init_task -- called from the init work, needs RTNL;
>> * idpf_vport_dealloc -- called without RTNL taken, needs it.
>>
>> Expand common idpf_vport_{start,stop}() to take an additional bool
>> telling whether we need to manually take the RTNL lock.
>>
>> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com> # helper
>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>> Tested-by: Ramu R <ramu.r@intel.com>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>
>> LLM Generated explanations, may be completely bogus:
>>
>> YES
>>
>> Why this is a bug-fix
>> - The driver was missing the association between netdev queues and their
>>   NAPI instances. This breaks NAPI-aware configuration and features that
>>   require queue->napi to be set, e.g., AF_XDP busy polling. The patch
>>   adds the missing linkage and corresponding unlinkage, which is clearly
>>   a functional fix rather than a feature.
>>
>> What changed
>> - Link/unlink netdev queues to the NAPI of each q_vector:
>>   - Adds `idpf_q_vector_set_napi()` and uses it to associate both RX and
>>     TX queues with the q_vector’s `napi`:
>>     - Link on IRQ request:
>>       drivers/net/ethernet/intel/idpf/idpf_txrx.c:4043
>>     - Unlink on IRQ free:
>>       drivers/net/ethernet/intel/idpf/idpf_txrx.c:3852
>>   - Helper implementation:
>>     drivers/net/ethernet/intel/idpf/idpf_txrx.c:3818
>>
>> - Ensure correct locking for netif_queue_set_napi:
>>   - `netif_queue_set_napi()` asserts RTNL or invisibility
>>     (net/core/dev.c:7167), so the patch adds an `rtnl` parameter to the
>>     vport bring-up/tear-down paths and acquires RTNL where it previously
>>     wasn’t guaranteed:
>>     - `idpf_vport_open(struct idpf_vport *vport, bool rtnl)` acquires
>>       RTNL when `rtnl=true`
>>       (drivers/net/ethernet/intel/idpf/idpf_lib.c:1397–1400), and
>>       releases on both success and error paths (1528–1531).
>>     - `idpf_vport_stop(struct idpf_vport *vport, bool rtnl)` does the
>>       same for teardown (900–927).
>>   - Callers updated according to their RTNL context, avoiding double-
>>     lock or missing-lock situations:
>>     - NDO stop: passes `false` (called under RTNL):
>>       drivers/net/ethernet/intel/idpf/idpf_lib.c:951
>>     - NDO open: passes `false` (called under RTNL):
>>       drivers/net/ethernet/intel/idpf/idpf_lib.c:2275
>>     - init work (not under RTNL): `idpf_init_task()` passes `true`:
>>       drivers/net/ethernet/intel/idpf/idpf_lib.c:1607
>>     - vport dealloc (not under RTNL): passes `true`:
>>       drivers/net/ethernet/intel/idpf/idpf_lib.c:1044
>>     - soft reset (usually under RTNL via ndo contexts): passes `false`:
>>       drivers/net/ethernet/intel/idpf/idpf_lib.c:1997 and reopen at
>>       2027, 2037
>>
>> - Order of operations remains sane:
>>   - Add NAPI and map vectors, then request IRQs, then link queues to
>>     NAPI, then enable NAPI/IRQs
>>     (drivers/net/ethernet/intel/idpf/idpf_txrx.c:4598–4607, 4043,
>>     4619–4621).
>>   - On teardown disable interrupts/NAPI, delete NAPI, unlink queues,
>>     free IRQs (drivers/net/ethernet/intel/idpf/idpf_txrx.c:4119–4125,
>>     3852).
>>
>> Impact and risk
>> - User-visible bug fixed: AF_XDP busy-polling and other NAPI-aware paths
>>   can now retrieve the correct NAPI via get_rx_queue()->napi.
>> - Change is tightly scoped to the idpf driver; no UAPI or architectural
>>   changes.
>> - Locking adjustments are minimal and consistent with net core
>>   expectations for `netif_queue_set_napi()`.
>> - Similar pattern exists in other drivers (e.g., ice, igb, igc) that use
>>   `netif_queue_set_napi`, which supports the approach’s correctness.
>> - Note: In the rare request_irq failure unwind, the code frees any
>>   requested IRQs but doesn’t explicitly clear queue->napi for
>>   previously-linked vectors; however, `napi_del()` runs and the
>>   q_vector/napi storage remains valid, and normal teardown does clear
>>   associations. This is a minor edge and does not outweigh the benefit
>>   of the fix.
>>
>> Stable backport suitability
>> - Meets stable criteria: fixes a real functional bug, small and self-
>>   contained, limited to a single driver, low regression risk, and
>>   conforms to net core locking rules.
>> - Dependency: requires `netif_queue_set_napi()` (present in this branch,
>>   net/core/dev.c:7159). For older stable series lacking this API, a
>>   backport would need equivalent infrastructure or adaptation.
>>
>> Conclusion
>> - This is a clear, necessary bug fix enabling expected NAPI-aware
>>   behavior in idpf. It is safe and appropriate to backport.
>
>While it's more of a feature and a prereq for XDP support in idpf, this
>generated explanation is actually good and precise. I'm perfectly fine
>with backporting this.

Thanks for the review and feedback!

-- 
Thanks,
Sasha
