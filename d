Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD601FC7F6
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793391; cv=none; b=nXadmtXFg8pceKjeU8QV5pDpdPyXlroGJtIbOkNa/lnkjfx/dFaULNuYz3kKUoP7a0Mmo0eyB6mReW6vdDp4NZnoKk1AlRurfLywQEkRO2a9bOTsXQV7/BjXvZsCnh1aE5npj5ZNix0eV6NPiAJw0Pfilpml+/dJBXvw2aBLq1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793391; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBhd+O5mWCDRFySVMhnVzyU8Nb7ND3G5IaEDVP2F4vUnlSMtc3bxVl8UeafjPlQmyIft5n/UPaDEgi5YlTH9V5CmYxrbFzb5cTmYAhdijqA579O9Xj3XgzO0zD1WLDq55QlXeY5wl5vNosNRMWDeQgyZEWDo3HrAnm1vfd/G/Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kUkFOuNf; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kUkFOuNf"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2fb587d0436so13382771fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=kUkFOuNf1lsQkTbYQnGKZj0L9xVh6u7At4r3FFeFEhvogHyc8xwj6GX4KACCZJvHgF
         ydvfTMU3z3K967Swb8P8Iz+sVu50d/l6ZKWr54zz+IU/Oxyzaz7HXeU4iEriZkwi46TH
         WTqFTMcxQTGZJQ06eslXKEUM5AUNfCAfYtMF5YG42uAvl9U37UMHEDAFvmadbWcusmJN
         bfZt+ypak/cLDpYp/P9naWulRaNhvwOzx68+2aXGdfoI0NxkYGcLz4AxY/upqCk0g2ZZ
         L+w4a5QbmO+swqpKwfK2ylZtQMXwcieh4K3VrnhRm/pn/4jp3cA3EngETjAcAEd991x9
         Aiug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=JDkKZLV/91WOmYAKJYmB+w0kwzRokSFlztFzwZWZupPH6v+dyi1ow8s0tz5b3bmj1d
         3yRT1bFgvYVSDVEJPmwXPaevyh/OcKtors7205CGqkB3RgahPjFWbLNbGzTJM0eThOmq
         nVihCSmf8Ncs17d869akATc2FsOgBqhTfwGrym+c1vg7d916G5GlQ6EmGyRC2oxxcpY9
         ixqyK5LFSNFeGdFt+i++3IR3LFp/74VLhlBo4h+p4erTyosG+B0+l5sc3j/0W6ItbUrM
         ikQukIU5rSt5u+Lh4JI1fyyp+VmQ4bpRn6oJEw2AQIqE4O1/doXUjAP2tLLDh3UtA+Jo
         vlFA==
X-Gm-Message-State: AOJu0YwCEHHzy0166Hd8llwYd2v3WkJdFizvrbvdEIMACrd3/pJae1sX
	Fyy8t0p7+G5PbbZuGmTj1WHzQVMP2LmooY2qU/qJnY4nWF+WtEY6tHOI9NfT
X-Google-Smtp-Source: AGHT+IFQ5KOAfGGyhvCyCTYHnOS6KNemUSeQxL+47ncyFUm+mHIgT+OpuJj7aRKD95oMAejFiLaX3g==
X-Received: by 2002:a05:6512:2211:b0:536:a275:9d61 with SMTP id 2adb3069b0e04-53b1a302ab4mr4556637e87.21.1729793386978;
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5556sm1423459e87.8.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3287-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
