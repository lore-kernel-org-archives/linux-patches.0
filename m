Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A23484258
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 15:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784821355; cv=none; b=lmv9wazlxGVbS0rAZgO3dAXZv6nfJ/6fQqa9W2eFT8inN1UTfVqHrqpQmN/IjblTzXPMTzw26KyrtuWu6zmKC4ALYA1/VKRcuB5YpBbwkJH00hvXMkIS38Hi0Aa/i/fAU06JRF1QVTKaAiFprpmSKULnps8cf+Eam1tGSHe27Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784821355; c=relaxed/simple;
	bh=IMCteS0TkCJHzDjkyUcXTRrsMb0f9nU5nsUZPMDjPvc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZXTMGomz5y7bUPDORjtVt0B9WZovfOgoqXToY+EYlSuUgOQSqCr8VHux2cI7osQSRFrgh2/xFKTbv8YIILDq4zw9gQWXGBRquwXg6dH+0vgOXiMHf19cSH1gqQ2M77YNARPznjRCJ4kaYtxb97xlr1orZ62RNDmdKAM8n5m4Iak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F092414051C;
	Thu, 23 Jul 2026 15:42:27 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 672CD60016;
	Thu, 23 Jul 2026 15:42:25 +0000 (UTC)
Date: Thu, 23 Jul 2026 11:42:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Yuan Tan <yuantan098@gmail.com>, Yifan Wu
 <yifanwucs@gmail.com>, Juefei Pu <tomapufckgml@gmail.com>, Zhengchuan Liang
 <zcliangcn@gmail.com>, Xin Liu <bird@lzu.edu.cn>, Huihui Huang
 <hhhuang@smu.edu.sg>, Ren Wei <n05ec@lzu.edu.cn>, "Masami Hiramatsu
 (Google)" <mhiramat@kernel.org>
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in
 glob matching
Message-ID: <20260723114247.00a3f66d@gandalf.local.home>
In-Reply-To: <759ee068-9519-4cfa-9be5-1deb0d9fc877@pobox.com>
References: <20260721152355.667394603@linuxfoundation.org>
	<20260721152358.800887633@linuxfoundation.org>
	<1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>
	<2026072339-reshuffle-blizzard-42e9@gregkh>
	<759ee068-9519-4cfa-9be5-1deb0d9fc877@pobox.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 672CD60016
X-Stat-Signature: ngtqam5na8cogsmrwc9h6y8yw5yg9h47
X-Rspamd-Server: rspamout07
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+tabRYN6EnByD1jz6S70rHsE4yQNJdNz4=
X-HE-Tag: 1784821345-894478
X-HE-Meta: U2FsdGVkX18vopHa6K3xj7jNALf/lh3TnbYTZ1OMweidMbRa63fCFtEwp/2RedbQKdnrC98bMVUcsUoyAkG2D7yBEgll6bLRDFgwFJRSwGprcdW4wwyKGLifelOEd/HJXK2qszyWo6hX2G2dfejSmqj+bcLNO3qXEX+mRY0AjH6Ofto+h9NgKfFoMnNPbYx2vXwYcLy1iXJp9mlZBl7L4NTj9aXW22k7BizFe5Itfwj6BZSlUyILZxNt7p3vJmBG5pxaFt4mBFNVlOTKiauMrBjlQIIQ9XH+yqGlRuwrGBZxdWwyebr8DcAxNhta53JLU95IB/GRnsf5ydZbpKoE9WP00gThVhm5cBPXh6Ly/4yNNW3GVJac2hUhP1ZjZKM3

On Thu, 23 Jul 2026 08:32:23 -0700
"Barry K. Nathan" <barryn@pobox.com> wrote:

> In the process of testing, troubleshooting, and eventually bisecting this,
> I've tried rebuilding the kernel from scratch maybe 6 or 7 times now. I've
> tried on two different build systems so far, and it seems deterministic
> that the build succeeds without this patch and fails with it.

When you say "from scatch", do you create a new directory and build there?

Is it reproducible with a "make mrproper"? (Need to copy the .config
elsewhere to not lose it)

As I don't see anything in this patch that would cause filp_close to be
unresolved. Sounds like a bad object was added somewhere.

-- Steve

