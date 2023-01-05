Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E918BE0
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 14:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1560CC433D2;
	Thu,  5 Jan 2023 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672927711;
	bh=nrx5rFy/NuygorsE+kWgn3I6xCfjKYugGy4omgwFW98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bcl6IMcrfXpFcDGMoiXIMmy9nI62G1hcKxubSR/VTW7VbaLNpK8zwUb+suZ+rESfx
	 58dI+TUTyw2OB5Xi7MtEqYJzusuaoO4Dris1uhg+EEsQxWFGwZ4yDlZSCvOy51S9mT
	 VqaIGBsFoY6JAi3IWhmSFKCAqdgpzBMnnDPAvH5dF5XbY2hvlW87HjvGcC9M9n9sPx
	 SnFT1nGsgiuKjoInJc5VEHDk5+wb/n6AsCu79m3llM2lUdj4fnlArAiWFFPFeIBFuM
	 V0RenKkSyYiH13Oy4gSHOikyWB5xTpx/XkYgm2nsZe8x1lNS9JOcJH887Mvd+mS/WG
	 i2wwEKCvqIOCw==
Date: Thu, 5 Jan 2023 14:08:26 +0000
From: Lee Jones <lee@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	John Keeping <john@metanate.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 481/731] usb: gadget: f_hid: fix f_hidg lifetime vs
 cdev
Message-ID: <Y7bZ2krq2uvjJqRR@google.com>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144310.493605271@linuxfoundation.org>
 <Y7bACmZQdEhlf121@google.com>
 <Y7bCgNu1ZXlCHmPm@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y7bCgNu1ZXlCHmPm@kroah.com>

On Thu, 05 Jan 2023, Greg Kroah-Hartman wrote:

> On Thu, Jan 05, 2023 at 12:18:18PM +0000, Lee Jones wrote:
> > On Wed, 28 Dec 2022, Greg Kroah-Hartman wrote:
> > 
> > > From: John Keeping <john@metanate.com>
> > > 
> > > [ Upstream commit 89ff3dfac604614287ad5aad9370c3f984ea3f4b ]
> > > 
> > > The embedded struct cdev does not have its lifetime correctly tied to
> > > the enclosing struct f_hidg, so there is a use-after-free if /dev/hidgN
> > > is held open while the gadget is deleted.
> > > 
> > > This can readily be replicated with libusbgx's example programs (for
> > > conciseness - operating directly via configfs is equivalent):
> > > 
> > > 	gadget-hid
> > > 	exec 3<> /dev/hidg0
> > > 	gadget-vid-pid-remove
> > > 	exec 3<&-
> > > 
> > > Pull the existing device up in to struct f_hidg and make use of the
> > > cdev_device_{add,del}() helpers.  This changes the lifetime of the
> > > device object to match struct f_hidg, but note that it is still added
> > > and deleted at the same time.
> > > 
> > > Fixes: 71adf1189469 ("USB: gadget: add HID gadget driver")
> > > Tested-by: Lee Jones <lee@kernel.org>
> > > Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> > > Reviewed-by: Lee Jones <lee@kernel.org>
> > > Signed-off-by: John Keeping <john@metanate.com>
> > > Link: https://lore.kernel.org/r/20221122123523.3068034-2-john@metanate.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/usb/gadget/function/f_hid.c | 52 ++++++++++++++++-------------
> > >  1 file changed, 28 insertions(+), 24 deletions(-)
> >  
> > Dear Stable,
> > 
> > Would you be kind enough to take this back as far back as linux.4.14.y
> > please?  There is a trivial fix-up required for kernels older than
> > v5.15, but it's the same fix-up back through v4.14.
> 
> This is already in the queue for 5.10, 5.4, and 4.19, but for some
> reason not in 4.14.  Can you verify that the 4.19 version works there
> too?

That works.  v4.19 isn't required.  Thanks.

-- 
Lee Jones [李琼斯]
