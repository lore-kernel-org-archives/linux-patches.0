Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486C1FF7B7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793424; cv=none; b=Oz7DSyFHJQqR9yjFmDXK2ATlyojvpMmJte0r+eCpBdbTt7QPkOhNv/Gl0o5akz9h+2h5Ywui1Tco8oNWFhxfkJN6Ipivoy4C79frcnAoaxDZ2Vmk67oADu3B6QpAEjQjV59BFT1VJdSs+gBqKaQ1a0OLBr+ylvUrp86Gu4qcwx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793424; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPxdlYYGgrR5HLsI8qSO/Dh1x/SthLzDae2OUfBMa99j+qnsGqFXVLBvF2Zdi70fdDpFY5KoxZ5YruG484gecAPWtBYVCwfvonjtTMu9NTOJX4E+XfXGRrzQoach4BGfC0/xYB8IrTfesdHGc1hzlTrw49lFUqUo414biJDcv3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lm2cwUae; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lm2cwUae"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2fb56cb61baso10116621fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793420; x=1730398220; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Lm2cwUaeBlv+omqkxzC5Q5ZvjDZGhJqesqU+nwZNg1iWCSeWUIkVtrJqRgm4MyrTdy
         rkycV5KbrJaV14D0CCW0VrcScxDW2ZEQsaeHHgKYn62xA+btrexAkm77odCjdKmW98la
         J5EeA0wdxViHqFyFKA93z9Wi5ZqbJ12PK1qkoSenw8gqor5fGPSGE06DEb/0MZsWrD2j
         UVlJAst7nOt4PP5C6s8ME39CZriWW+WCT9UA659+vEXULm5xLy/DmiM7NfJ9MCrrROXH
         N4RF125qmNHwPrBBkHltR1Qek+NhVg5CMrOlWNkySCWEMQLROIVeQHDnVotNLmu/sR18
         vnew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793420; x=1730398220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=NITn6S9tYgj9JztKkE4O8z+9mxhGV8nk9MJR/kXq6kycJYebzp95FudtuE2esdGXyu
         ltZdtzIDnOeOkxtsS2GZewo1wHsTwUqZ+4qRn9pfNtSmoJe9FrTu6umWeeDB5R0EOmMv
         lkfht7681d3l/0OlGE+DT7vHtmWDPHh1cmoc2WwPiz++RGqE31rkANbcmO/OH1vq+1Tl
         nn+p5vrUjAE7JnHW6ldM65Bq5gRXNizrET8A/1Dlkr77UOIUi5eJlqdurkF5nXldRKbA
         8YG3hCpQUjGCOaxYsU/CQe/rMiMCUEG1I8IsBaztNsFFM3vSXdwG3C9eGn63JtDxO02F
         lCgw==
X-Gm-Message-State: AOJu0Yy/XaWvKdLFEwnhljvUuw0vGn6sYdLuZxIn/oiIKBdqzvRkcv8r
	xHb7I10Ks9H9GrqHaCaFptvw1L7HMY9UOFdXs0KLJUoVTX4z60bqa+SkDUx+
X-Google-Smtp-Source: AGHT+IEQ6cP6FsVkLSUAWlx0NSjRyX+K4I9DdZS6gqMmU6ao7knITTzvTPVdRkPlq1snUUQ3xAXApA==
X-Received: by 2002:a05:651c:542:b0:2f7:6812:d0ae with SMTP id 38308e7fff4ca-2fc9d3460b0mr41339061fa.13.1729793420000;
        Thu, 24 Oct 2024 11:10:20 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad75abcsm14353901fa.46.2024.10.24.11.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:09 +0300
Message-ID: <20241024181009.8171-1-vladimirputin693389@gmail.com>
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
