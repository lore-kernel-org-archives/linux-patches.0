Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7DD1AF0C4;
	Thu, 24 Oct 2024 09:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729763659; cv=none; b=b9cBpq/1peoRtZHZ4iPkLmMrnXmktHQloBRcG9vvxnHWV/9F4LE38LHSG8MXjz3elXjoLfjhsOQCBwFZpRI+eOVmslFquAUWVL5oG//sxKXOfhWWSMwp42hGuTdYGy6Fnn+dkCT8nzmuL4jacHZ/y5T0+Ls7CB/jL4r6DofAedk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729763659; c=relaxed/simple;
	bh=FKxWNgpm5Kd3t6VYzCpTSntmFd4Q0I0hT0G3IkO8d/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tPKOivUXv2Hv92rM6fvwzWvz1FfQi/IyZlDa51E164YZLou0sQNuP3bH7nWz/q91sX9/ObddMnqP6OMSljVJ7lt7YN1MPM7MMiVGTCgxwZ7V4ByiQGMM4VzOM6OWJNDrbIDs7faqPX6hwAVRnYUnlnniwIkabk26a2GUudiLSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghWJJcgk; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ghWJJcgk"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539e63c8678so750892e87.0;
        Thu, 24 Oct 2024 02:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729763655; x=1730368455; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dWFrbyngtx/okFnAnXziGIwpshdD52HD2rAoJDGqVCM=;
        b=ghWJJcgkh2l8aTP/ifP29zS0ycpLDA8cjQ6r4Or1lgUFuGCSxgJg6aqJGF/3/JD1BE
         NyUG9/OhRHNkrqDkGjbdu8qT95fNmbLl7O5RRWivV4Yu5vu8EIf+/irmzPttNgqxPj4V
         XQ4IQy4+a74xLUAYo/LvIr6FM3r8yhUSpLcahCDpzS/PUzHHl7oYSKnBr+xRngFu1ZPJ
         O3ZC/r8vmt43zuVpWkdLONe6Fh9OVlQW8uLj5AYiXGUPcQT+xysLq9AVUNMU9JVKhyfM
         7YRb+GVBzdfmyf0LrQrrlzouNTWcI3Kwvm+zrQDPmD0CqOaCG354wltLImlduTN2pJy+
         hnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729763655; x=1730368455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dWFrbyngtx/okFnAnXziGIwpshdD52HD2rAoJDGqVCM=;
        b=KyyPv6yY5Ul/Vc5ra8SsjU2Y0jIFNjlFNTn05TmF/xRhoIAPHGjfWeU+cxlg4OAbwI
         OkhGHzAr5WM8SiqMBdeoEMrbBftEqgKjDFbSLkZEUNmWnySEWfufYaXmr93OdCIR1544
         ZQet4j/Rrbio9JF0NUeAXzYMmPV6QDhOHVCec6Xj4bThfLmb+lXtEhNzJ1I1qLi0Qrth
         1Y+QslazU6RkGGr7ZiTvYQ0Vc+HyChl/uwZqetF0DsbtnHAWOMAfjCzRjatXe/i6wIie
         pcR7tZVVgcqXl6g19R7vAAsRaHWi17TTpYqS4GI2i4ZpY5Z/QsMSviG4uNhbd+GC5Rts
         fBbg==
X-Forwarded-Encrypted: i=1; AJvYcCWVwsrcaqZLJHfAyKBZBLaLFqEeWpmIj+zkEgj1SdTT1+Wb52bq6VB38HO8NfZ5e3+ifNk=@lists.linux.dev, AJvYcCXf08THuy0LLGdC5ou729IkcMjD4xxWDTUgQg7DciP0203Kab8Bqf8QQuzGo3csCWWtzU214QSk4A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyBeIhDCkam8SNFTTqzN0hLSmV22zQFVOHD41Qsc1es/gS0VDdF
	wsA+8rF1nsLdfsvN4IUWC/PMT1zu/EQkqo1TzUwEQldHhHAHBIwR
X-Google-Smtp-Source: AGHT+IESS/b985DjGqxcVR4TpFmyKByLbgcGL5xpKJP8FcedH7Cq7mq7giZwGEwbp0hOURP0H6AUbw==
X-Received: by 2002:a05:6512:1583:b0:52e:9762:2ba4 with SMTP id 2adb3069b0e04-53b1a315eeemr2629947e87.25.1729763655208;
        Thu, 24 Oct 2024 02:54:15 -0700 (PDT)
Received: from [10.110.248.100] ([79.110.251.190])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b1ade1875sm455020e87.18.2024.10.24.02.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 02:54:11 -0700 (PDT)
Message-ID: <3448a096-849a-4f61-8017-c03a83e22c38@gmail.com>
Date: Thu, 24 Oct 2024 14:54:04 +0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Tor Vic <torvic9@mailbox.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, jeffbai@aosc.io,
 gregkh@linuxfoundation.org, wangyuli@uniontech.com, aospan@netup.ru,
 conor.dooley@microchip.com, ddrokosov@sberdevices.ru,
 dmaengine@vger.kernel.org, dushistov@mail.ru, fancer.lancer@gmail.com,
 geert@linux-m68k.org, hoan@os.amperecomputing.com, ink@jurassic.park.msu.ru,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-fpga@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 linux-spi@vger.kernel.org, manivannan.sadhasivam@linaro.org,
 mattst88@gmail.com, netdev@vger.kernel.org, nikita@trvn.ru,
 ntb@lists.linux.dev, patches@lists.linux.dev, richard.henderson@linaro.org,
 s.shtylyov@omp.ru, serjk@netup.ru, shc_work@mail.ru,
 tsbogend@alpha.franken.de, v.georgiev@metrotek.ru,
 wsa+renesas@sang-engineering.com, xeb@mail.ru
References: <a08dc31ab773604d8f206ba005dc4c7a@aosc.io>
 <20241023080935.2945-2-kexybiscuit@aosc.io>
 <124c1b03-24c9-4f19-99a9-6eb2241406c2@mailbox.org>
 <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
Content-Language: ru
From: B4D_US3R <producerkgb@gmail.com>
In-Reply-To: <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Grandpa, take the pills or you'll get your ass kicked.



Дед, пей таблетки, а не то получишь по жопе

23.10.2024 22:45, Linus Torvalds пишет:
> Ok, lots of Russian trolls out and about.
>
> It's entirely clear why the change was done, it's not getting
> reverted, and using multiple random anonymous accounts to try to
> "grass root" it by Russian troll factories isn't going to change
> anything.
>
> And FYI for the actual innocent bystanders who aren't troll farm
> accounts - the "various compliance requirements" are not just a US
> thing.
>
> If you haven't heard of Russian sanctions yet, you should try to read
> the news some day.  And by "news", I don't mean Russian
> state-sponsored spam.
>
> As to sending me a revert patch - please use whatever mush you call
> brains. I'm Finnish. Did you think I'd be *supporting* Russian
> aggression? Apparently it's not just lack of real news, it's lack of
> history knowledge too.
>
>                        Linus
>
