Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075A13AA4C;
	Wed, 26 Jun 2024 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719421568; cv=none; b=f7YyZ9wakvFgGmm+fYBfXe+RoZzVdtOtS84epiYhmexNGVLt2vInFZX/GkevYZKj4/yIir7GIvv6lT/gKByXF1bZdogDDXRG1avXWJYTEvdMC4h/D13IeabSnj0ClVv1xmS9CD2motJwS64uS3tvBXRLS0f5kZh+tuYcWmQahq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719421568; c=relaxed/simple;
	bh=NGlqg/Pmt4gOfQtT4F33ND5D947m/+4mzw6M8io5Qtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cDC3gg8LU2484XuEL/KIvesD+9vWkj7fIJ5zgciXhqksncFZd9GReBlIRXqSCfg6shk8O7YvqzpkCtrh3yrzF9JzM4l7EPBqVnWNkhGuCqK+cl/uKNxzO/xDnoNLoAn3uGKVQpDu3bcAu4jVw78rVQlL8UrtHGJVRL2VfoeGek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfDdLa2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfDdLa2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6287CC116B1;
	Wed, 26 Jun 2024 17:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719421568;
	bh=NGlqg/Pmt4gOfQtT4F33ND5D947m/+4mzw6M8io5Qtw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UfDdLa2S1ysiOoxcviyR4sD9rKUYuwGOxvS6LdOZDp60i58O8O/zKNCx8xVqnx9Mw
	 LmGDsy869BKdL+jUwonXLt/4TSeOgToxdM3UkkmnmgKeStZkvrDWD+HPg9nwV90kBw
	 hqo4bf4F2QabTiTSb+kSwp0ey36OEiffBOG+YpQT3yxG2tf8dP8Nfa8MEXVqNoylDF
	 tBzYbmIZb/DWI0qNqLL6MQ5eSEjdoqhJTYO7Scu2Sc978nDTaO0QlF0QEExjOYQSvP
	 Zt+Fv7574L1eefswOYgYSBFZT+tIRYGWNzdwaj53LPSQWjCPgji+/zh1U7Vj6mhiwK
	 IuGPIDjAcC4ug==
Date: Wed, 26 Jun 2024 10:06:05 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: James Smart <james.smart@broadcom.com>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] nvmet-fc: Remove __counted_by from
 nvmet_fc_tgt_queue.fod[]
Message-ID: <20240626170605.GA66745@fedora-macbook-air-m2>
References: <20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-v1-1-286adbc25943@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-v1-1-286adbc25943@kernel.org>

Ping? This is still relevant and I don't think this is a compiler bug
that would justify withholding this change.

On Wed, May 29, 2024 at 02:42:40PM -0700, Nathan Chancellor wrote:
> Work for __counted_by on generic pointers in structures (not just
> flexible array members) has started landing in Clang 19 (current tip of
> tree). During the development of this feature, a restriction was added
> to __counted_by to prevent the flexible array member's element type from
> including a flexible array member itself such as:
> 
>   struct foo {
>     int count;
>     char buf[];
>   };
> 
>   struct bar {
>     int count;
>     struct foo data[] __counted_by(count);
>   };
> 
> because the size of data cannot be calculated with the standard array
> size formula:
> 
>   sizeof(struct foo) * count
> 
> This restriction was downgraded to a warning but due to CONFIG_WERROR,
> it can still break the build. The application of __counted_by on the fod
> member of 'struct nvmet_fc_tgt_queue' triggers this restriction,
> resulting in:
> 
>   drivers/nvme/target/fc.c:151:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct nvmet_fc_fcp_iod' is a struct type with a flexible array member. This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
>     151 |         struct nvmet_fc_fcp_iod         fod[] __counted_by(sqsize);
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> Remove this use of __counted_by to fix the warning/error. However,
> rather than remove it altogether, leave it commented, as it may be
> possible to support this in future compiler releases.
> 
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2027
> Fixes: ccd3129aca28 ("nvmet-fc: Annotate struct nvmet_fc_tgt_queue with __counted_by")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/nvme/target/fc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
> index 337ee1cb09ae..381b4394731f 100644
> --- a/drivers/nvme/target/fc.c
> +++ b/drivers/nvme/target/fc.c
> @@ -148,7 +148,7 @@ struct nvmet_fc_tgt_queue {
>  	struct workqueue_struct		*work_q;
>  	struct kref			ref;
>  	/* array of fcp_iods */
> -	struct nvmet_fc_fcp_iod		fod[] __counted_by(sqsize);
> +	struct nvmet_fc_fcp_iod		fod[] /* __counted_by(sqsize) */;
>  } __aligned(sizeof(unsigned long long));
>  
>  struct nvmet_fc_hostport {
> 
> ---
> base-commit: c758b77d4a0a0ed3a1292b3fd7a2aeccd1a169a4
> change-id: 20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-50edd2f8d60e
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
