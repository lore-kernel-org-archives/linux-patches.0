Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECB84438
	for <patches@lists.linux.dev>; Tue,  4 Oct 2022 22:58:20 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id u21so8733048pfc.13
        for <patches@lists.linux.dev>; Tue, 04 Oct 2022 15:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=bI0zGpTZLBQJOOWB4CpiQ3wDraQSecms/2au9Z/d6Ps=;
        b=R0S3tntjc5TLxkXtK9o8yONdES+h8vz6uv76pIRrKRnJwi+O2AIu1zGl6ygMvSqUEi
         /hVcJ8iKZPJgl28LKnLJUvHjkefOjTtWlqPgmz8mymzg0vecdCMnX3IJQVewQ3osMHLD
         cQ4Wm1JLK1WNyF1A/GBW7LfxBQbWAWpXyfdhpiuoc/UFjrWlVMDRwzGkqa61NV3mik+w
         bJm7KhJi5Oulxzi1oDDno/zFk69vGLSjfbnMZ2A+11LcNH2nWDrQKUZfaW4QNwRWD1/e
         /wInF3SXdL8YeZCuINCd4wBpmqeIb3U3iLkXPjd3JOZBSsHNBFHxCBThDOHSRihxcp5z
         2QvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bI0zGpTZLBQJOOWB4CpiQ3wDraQSecms/2au9Z/d6Ps=;
        b=Rr+aESa6G51KrQXwiazPCHz2F48ITUwsAAFdjjfFUwxBgWGidR9etqehSmqmZ+Baan
         PhBpSPTnRqiu7uB+vqm1P49MGzdc1NG928HCnIf05xcrxk2Kf0eLh7itr1dwB4F5zqxD
         vd5dI2FHnlMk5WkNsp7sY7PERFuzVooDGPMChNFmSmeZEQmecS4p3DBJw61VP/vBrS0L
         D248WN1c7koN9otJbjH8XW9ILJQjyvAiQr9WpoYQddVhTxaUOVfLCk9FD/IsetJxm4zx
         6fRGxhSKbKz0ctoP4i4nHs0WUZd2r0pB4qCKrXaO0JmQwMNNtjEJCLDNda/YWdo0pyaH
         DfJQ==
X-Gm-Message-State: ACrzQf3D2BKrrnLj6CfaLWIVzG9y6z1xTAzTERDy5vp3yx1usQvUTeln
	7GFE3PEhd1cQIX8b3qtzCdw=
X-Google-Smtp-Source: AMsMyM6JXaigRAqZEKMlG03o7/6XZ7DH+tmCJp/4HuGVvjpppRGn+F3xExppnI3ay/k69ueEr4vE5w==
X-Received: by 2002:a63:2bd4:0:b0:451:5df1:4b15 with SMTP id r203-20020a632bd4000000b004515df14b15mr8785014pgr.518.1664924299925;
        Tue, 04 Oct 2022 15:58:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id jm10-20020a17090304ca00b0017b224969d6sm456205plb.76.2022.10.04.15.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 15:58:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 4 Oct 2022 15:58:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH] debugobjects: Print object pointer in
 debug_print_object()
Message-ID: <20221004225817.GA2749300@roeck-us.net>
References: <20220519202201.2348343-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519202201.2348343-1-swboyd@chromium.org>

On Thu, May 19, 2022 at 01:22:01PM -0700, Stephen Boyd wrote:
> Delayed kobject debugging (CONFIG_DEBUG_KOBJECT_RELEASE) prints the
> kobject pointer that's being released in kobject_release() before
> scheduling a randomly delayed work to do the actual release work. If the
> caller of kobject_put() frees the kobject upon return then we'll
> typically see a debugobject warning about freeing an active timer.
> Usually the release function is the function that does the kfree() of
> the struct containing the kobject.
> 
> For example the following print is seen
> 
>  kobject: 'queue' (ffff888114236190): kobject_release, parent 0000000000000000 (delayed 1000)
>  ------------[ cut here ]------------
>  ODEBUG: free active (active state 0) object type: timer_list hint: kobject_delayed_cleanup+0x0/0x390
> 
> but we can't match up the kobject printk with the debug object printk
> because it could be any number of kobjects that was released around that
> time. The random delay for the work doesn't help either.
> 
> Print the address of the object being tracked to help us figure out
> which kobject is the problem here. Note that we don't use %px here to
> match the other %p usage in debugobject debugging. Due to %p usage we'll
> have to disable pointer hashing to correlate the two pointer printks.
> 
> Cc: Guenter Roeck <groeck@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Did this patch get lost, or was it rejected ? I don't see a reply,
and it has not been applied.

FWIW:

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

> ---
>  lib/debugobjects.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index 6946f8e204e3..a1c987e967e0 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -503,9 +503,9 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
>  			descr->debug_hint(obj->object) : NULL;
>  		limit++;
>  		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
> -				 "object type: %s hint: %pS\n",
> +				 "object: %p object type: %s hint: %pS\n",
>  			msg, obj_states[obj->state], obj->astate,
> -			descr->name, hint);
> +			obj->object, descr->name, hint);
>  	}
>  	debug_objects_warnings++;
>  }
> 
> base-commit: ffb217a13a2eaf6d5bd974fc83036a53ca69f1e2
> -- 
> https://chromeos.dev
> 
