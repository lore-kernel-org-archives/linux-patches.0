Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1831C500949;
	Sun, 11 Jan 2026 02:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768100086; cv=none; b=P70K0OYx8lj0KARklY3NW0L/S13cC7lGXTPLrPLfsl9fuvyCc1Brm8LzIYjyGgBApvQhblrpwKmZrtUW2wVOTTYFfioEGxioQckhKF/bswMuXt5E0CXcyufXqujxwccYb46jjhz4eDgfUCr1zqnZc1Nx9V5aLnjPeFCts0pdsZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768100086; c=relaxed/simple;
	bh=i6jotOoBbpVv9xV48SpL54eHutL6MGvxEERegruR3lg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Nih3kDgsyi9QuIWq8JM/m0ytJvJibfNnXrYFg/8KOpg3j5WsJpzBi92dJ/hRopNvMIWkwFM9avUsOD0v0NpjSS/QTF0eguGawRcQnZHX9zC/lRyF7nbLl0v0Gl/6uplo38GbPS3WBOfPKQi0NiqHeJ1rSFitRO1kKOjtMNqJ44Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IdF/PT4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IdF/PT4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66843C4CEF1;
	Sun, 11 Jan 2026 02:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768100085;
	bh=i6jotOoBbpVv9xV48SpL54eHutL6MGvxEERegruR3lg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IdF/PT4+wr4gHHqAOGM+4p9F1LmHt3FustF/5Dj2hcTqjHrqpPyswOgSxBO6tmZN0
	 hA3Ef8p7TGBw3cPECgria2rELuY42RfVi0sH3GJXsm7ANgLkg11RTeE+cg4uxW4ihF
	 SfzY3GQcLQ3ZRDatneiGtJ71NNZE2JeqVbdbed1U=
Date: Sat, 10 Jan 2026 18:54:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Eric Dumazet <edumazet@google.com>, Reinette Chatre
 <reinette.chatre@intel.com>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH] once: Don't use a work queue to reset sleepable static
 key
Message-Id: <20260110185444.3ccd7f6cf8b1bd319d3fa80b@linux-foundation.org>
In-Reply-To: <20260108232717.14411-1-tony.luck@intel.com>
References: <20260108232717.14411-1-tony.luck@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  8 Jan 2026 15:27:17 -0800 Tony Luck <tony.luck@intel.com> wrote:

> Pointless overhead to use a work queue to reset the static key
> for a DO_ONCE_SLEEPABLE() invocation.
> 
> ...
>
> --- a/lib/once.c
> +++ b/lib/once.c
> @@ -93,6 +93,7 @@ void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
>  {
>  	*done = true;
>  	mutex_unlock(&once_mutex);
> -	once_disable_jump(once_key, mod);
> +	BUG_ON(!static_key_enabled(once_key));

Sauron's eye is upon us.  Can we either justify nuking the kernel or
use a WARN_ON?

> +	static_branch_disable(once_key);
>  }
>  EXPORT_SYMBOL(__do_once_sleepable_done);
> -- 
> 2.52.0
