Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6696AAE
	for <patches@lists.linux.dev>; Mon, 27 Feb 2023 13:30:50 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso2172856pjb.2
        for <patches@lists.linux.dev>; Mon, 27 Feb 2023 05:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrlqkyNhx5Y9J/eloABTQEhuK4mEKVoWLJBJOEPVQu0=;
        b=mQU8pset9BooU3jzDqbQhgS4BYtT04chvJX646MRug8Def2PUH67YE9LLRZZjtxvoD
         6FnUwhoGoLGiTYUCCMEkd4JmJBsE+LslYcsK7xUe9t8MtYKAXHdUpk4CGxlIZbM1m3Dt
         FZMeMU4UGstobcZBN3TJQ5d1hZzZtR/F0d6dqDPEFNCD6AwGN+ZCJjVQxKqFBCQWoCFp
         j7M/xxiCgLQ+jcbD6kZqPpt0r9oZ+frd5oyfSIXHHB6/64KPvTb9wupL49KOCSsKlydB
         xaEI7pz/vT6EFDi4smuf+uxt5hOvVs9VYsLzdqFePVEtRmDd3kDS09OLeV7TRdLrj/2F
         YS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nrlqkyNhx5Y9J/eloABTQEhuK4mEKVoWLJBJOEPVQu0=;
        b=6yR8EU+VFgUYlWWNLkyHsJVefLmLYUTIqw4szNUnq+bm5gJveoVXpBHqhMiRB0FuNB
         iF+ypBrVX96v+moNac5kklQLgexJmaz5rQJwH8dI3IeWlqi6XJZsPf/ZFg/93bYXg643
         E8y9WOPyEpbEFctv2YA7PRbHRQTIEx3FrKqI/aCPRFyK1vhKMUDc/o/96ObB9fiWdH0p
         9RgPlP6R7wGAZGqSEnbVri1+Q/nFbSrrBAk6yNu+1RKhQVES73s0Fl8v8MiqSWz9O/sq
         6KdwfMSJe7ErJ1Ga28MnofvVJbAzyijjErzUW4qsE+7DUCVGn8pc7Yx/oSIAAAkWvrKb
         xi4Q==
X-Gm-Message-State: AO0yUKUnQKv8w8MESRog+lkoxLyl2xM9b+d8xDCkwXMgflyo46cULf4I
	58MoqnkRnAtsp/EOC5yErkfLRfitcO3Z2lbdaWMVHw==
X-Google-Smtp-Source: AK7set+y9/1kpprFY1OXKEHgrB85hu8mL9Xs/CkAgyUFKPWIL513Klt7JDZqMu91zLA0aFlMVuNpZvdkd6ZWQ9+Xmps=
X-Received: by 2002:a17:902:ab07:b0:19a:7e41:5a2c with SMTP id
 ik7-20020a170902ab0700b0019a7e415a2cmr6144088plb.2.1677504649857; Mon, 27 Feb
 2023 05:30:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230126184157.27626-1-tony.luck@intel.com> <20230126184157.27626-8-tony.luck@intel.com>
In-Reply-To: <20230126184157.27626-8-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Mon, 27 Feb 2023 14:30:38 +0100
Message-ID: <CALPaoCgnOWLdEqKtonNeq+d_Fj0yr3Y7tgwwmAHmuhL5xBhqyg@mail.gmail.com>
Subject: Re: [PATCH 7/7] x86/resctrl: Determine if Sub-NUMA Cluster is enabled
 and initialize.
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Shaopeng Tan <tan.shaopeng@fujitsu.com>, 
	James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, 
	Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, Jan 26, 2023 at 7:42=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
> +static __init int find_snc_ways(void)
> +{
> +       unsigned long *node_caches;
> +       int cpu, node, ret;
> +
> +       node_caches =3D kcalloc(BITS_TO_LONGS(nr_node_ids), sizeof(*node_=
caches), GFP_KERNEL);
> +       if (!node_caches)
> +               return 1;
> +
> +       cpus_read_lock();
> +       for_each_node(node) {

Someone tried this patch on a machine with a CPU-less node...

We need to check for this:

+               if (cpumask_empty(cpumask_of_node(node)))
+                       continue;

> +               cpu =3D cpumask_first(cpumask_of_node(node));
> +               set_bit(get_cpu_cacheinfo_id(cpu, 3), node_caches);
> +       }
> +       cpus_read_unlock();

Thanks!
-Peter
