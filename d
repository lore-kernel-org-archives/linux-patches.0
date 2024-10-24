Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF8C1FE107
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793396; cv=none; b=FzRs05nUS5vG7utPCYT4IwnsNbeakEXAXmJTFXqILCad3CgUtBUsC5x4OQ/O/LaCMU/8+8z/mF0RDP4OlEsiV1MLeE6uCNr4JglMgwK1EQ3vvJeXJYM8PNnx4kJRH6b+i0jyahtdKNOnln1CnD9tbHxolkhkekUjlMcfVJIawOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793396; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNPesTR1JOvv5uBzWSbCFzilPbl2KgMniBovcvYZ8XX014ytRJxo4H/8Ei5XW+BYsRgLWLlnXFfOdcFRLWvHbFHfpsUHVcBncSk7YXt7MQ1dBXjKz5IGm47A4qRMkRUTw9St+Saw8WhQ79/qoxvrDoUQB5G/sHGLkni1xfoUetU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MoUFEXBB; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MoUFEXBB"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5366fd6fdf1so1727408e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793392; x=1730398192; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=MoUFEXBBVE81z19zoeSwcqccDTXryREFvn5f+5Xu/uVdANQyJIRoFm9VCpCWX10Jha
         WcaKoAXoMX2h3BLIit0prGe/MYV3sUi/pEdUsma1Xj8oYr4ufflbZ6WhnBb+P3vAO+up
         wveBpJlnmVXVYZIduK2ZAG5fTHRKnfaPwPBQzkf8q2/j0OxOAsTk+eoHYdTWFf4I4T3S
         VDHeoBSiO4k6gtydy5ksTGVvpZtgqqdc4Ujyqm2Tt9JI3VmxvX4cSSgbS/MIQ97lt0dC
         iEAgOH6ql4gRstfIrCUPaM57vE6mXxoAemD+kGXqLoEU+EEVtfl9XW8Xw1xGHFBsIbqp
         vEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793392; x=1730398192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=m1iRlOsilSUrFpaeI1WC1fuhElSS1EplO93v+qDa3qJpwqkoFyCnXAMFnoKdaQw5mN
         m9jRn6dFGmNntcslUHP3/YvI8ZrW5QNk0jHys55we3j5ypDZpDMm/HwMYv42HA21jWbz
         /6Sen2tHQtn5e3F9S6KWsYC4BN0Gd9Ya/bUTNz7GaiYg9Y/xb3n8pVYIuIT7Wp6GKeCS
         xVm4+kVwjPy/2/HtGUIzhybd/zH5aatMOyWJOsBTkoeQeqrOfuXP8FUJkenwP6dcAq9Z
         GfqyIUIRtp2Fy2TnYv167qm5VIJGt3E+BQX0ErMXUA3I7BwJDrOPaMxPbpzQu7Myb9Kj
         vu/g==
X-Gm-Message-State: AOJu0YwdZDTlYYLxTHJVtUWRRr+QWF11vsAEIikJn/GOBYIboAuyxFdI
	K8SuYJu9kBedWhtjsysQ+cMA3HCRBJFigyZxhPrKXslbw4UNmjTk
X-Google-Smtp-Source: AGHT+IFBiLyMcWJlGIXHytUDN1E5W0oYrvvVtNhygUHsN0DqlBws4XG7mXF46D7JLaB1TVPODBmgKw==
X-Received: by 2002:a05:6512:3044:b0:539:ea7a:7688 with SMTP id 2adb3069b0e04-53b23dded9dmr1523030e87.1.1729793392371;
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b22b16068sm284856e87.10.2024.10.24.11.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:43 +0300
Message-ID: <20241024180943.3769-1-vladimirputin693389@gmail.com>
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
