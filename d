Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471D71D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793403; cv=none; b=ip1h+nMPsu5fqNS62dQJCG/SWqYEDM1CMNcSs5f8VLnnooL5uu1MsUIubFRgN34sWiPOGMOUubmTMWXjBSuUz4/A7EQ6t8RtJ17m9RGF7OYdKnG28bSQiPIdecqlYlB1BVQGGBbEZ2YC7+VG3dPrGPb6W7KH+0jbwdKW/z0gyWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793403; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApcCaXBPCKYxa5oR2mvXD+arLMKeGnDrpPZR50j3OheYRDeouMcL9XHlc/K99lTiXCw2RAtN0Yssy9bJc6NDzmrF7eLk62iJvHr3UT2iBbn/r2ve5B66VJM5wOgZBWtsJ/JQ1xpRRMMK2Ir6mgamy6q9shMNVKOWkbYfslqR0Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vimt5AwL; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vimt5AwL"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539f4d8ef66so1810982e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793399; x=1730398199; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Vimt5AwL1/ULLI4dAmc1F32AJORUxQRyo8xrbwfZK/8PQRieYinb8WorjIJ+hElyVF
         WsE9y9UOUOpkr7eLp21K0l1QdvK3FeL2Wy5qOhC+n3nz7jrQakyM5bHyjxyaASANklKb
         mL1N3/s27iG9zH1hZtxFEP4limKkhjNhZlZt0ER+cyVhOdPhAoVM+MJ+pyFMjXtsZqev
         EZh3VFv2Khn8wRkFd05NF/kNlUHkiEDYM9i1wQ7JGTMAQZ5N8S4rq2H5hdIgemKZu7ID
         bPz7VfCPT84IH5tWpMZ/sQmxJ1MdeOsMk/F4rTQ9zy14LoWks2tR6VVq/vt4+slCzzHg
         XARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793399; x=1730398199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=eYyguPtV6tnPlJTrbi2UiKNkWFJyLg4+DIr3UtdMScYRK7Fo/yyWPvKwHYXZIEh2cf
         778qUavEbgDXv8p4jtKBWplHKTVJk1ik3hPHCDseZ+bkhqKz88IbBmlgkmYdZibxjnRy
         fvjkKBrIOrYYyf/TSmxE7b8NsVnVUd6tTCRQeMbKDvwcsUF+gD2uowLumaGTF/ERGO3C
         p6j+8a/8mSiSxLbAx89w8+GICjH06JuHcqZONA0Qkf89GthFG2jaxbJK+AfvqcjpnNWq
         +aNjf33XyUe7EhkVwsSu7uNRQ0x/f/YJmtN2M3dhML8e/HxDxdhRMBLxK8+ZgtNGFLuD
         AAoA==
X-Gm-Message-State: AOJu0YzPBTMtqVnzCm5LVzzXxo5qjlnfpvwwEAS4tOecTvOZewTAIlcL
	IrGghRRiF2N8CWOLYP0JM4+uIUKgDT6kANzivq8bUwCvJD4JckT9Mt/Nr1qy
X-Google-Smtp-Source: AGHT+IHeqONBJatvjWgq1cHn+2aAQDZSuq3SdmNCDl72VqMcgYvE9CO+TN90JRs4BRD09h5859KNgQ==
X-Received: by 2002:a05:6512:12d2:b0:539:e110:4d72 with SMTP id 2adb3069b0e04-53b23e9deb5mr2235741e87.56.1729793399396;
        Thu, 24 Oct 2024 11:09:59 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b139a7fefsm884096e87.106.2024.10.24.11.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:50 +0300
Message-ID: <20241024180950.5285-1-vladimirputin693389@gmail.com>
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
