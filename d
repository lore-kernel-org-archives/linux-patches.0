Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED17200105
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793416; cv=none; b=CpUxdgzxOYuImbho0/ZS5CnX5Y7m7AxYsXwdTGi7YqOk+s9kY8w44629a+zpAiy/bcOQ7MjU+d5nMXmZeIlqcUcvxY7n9rs9moJBHg3UjNcJbKTpec/lKJ/3Uj/LwyV/2DsQ18vbGuucSkZgf5c5L94n8xtP/LgIEiZLKe7WsHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793416; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSzO2H9a5ziAzIa5BxvgKUSKAiIK4yVnMde200ZsuBmBzFufoTsj4P77JlA+rIu/z9AyPZrC4yOICdHI8PmFp16GcyklB2ZLVD6KecEIgZqCMy3NzF8uygHfkLIqSY5dRdeReBpEWSjput5MQUEcNOwt5r83BQqlhzpSGCMdbOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hgceePbN; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgceePbN"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539e8607c2aso1484095e87.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793412; x=1730398212; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=hgceePbN0GbM6+sKVNaYchjUtFAfAneyALqx7ODzJgJvIW06EmQsjGmb3yJtLC92NF
         zwFH5jHuW9BrdLZtqZ08MgnxJIc3R+VS4HcY27czSXGXq2j4f6EQO9zYakvLWe738t/A
         tnBr3hUy1mWXMrM/vveN+3xeKHqR/eLqKqp3S5lf0Cyq9f1xd+YzKy65ghvzoNWTZyw2
         olgm+eCPmEQ+3dSHT5ddadP7L2iQfeHumFnQB5C+vSA/muHLdbm2kcFn+vJjMl82gYjP
         CgZgwlcFMElxS/XeWCk69gd8QkvZf/DHsS/sE/hke4ApotcEcM+wt0I9BxDXzCCS1SDL
         M1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793412; x=1730398212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=tnfoh6/h2LzbP5/N9eZESDuzB2hE2DDh4SLWA/KMpsVdaKOsKdZMn56UoCyCpUC5Pg
         rmct1JmJ9xdQEGXG5ChYZBaKnp0ouJfiLDBtLXdebMHlHaQXsuh9OgQQPyKrLajGsyxd
         r/LFZFr83oU96BQhp7hRmtJbVoTn3b0Dx61OL/uij+d6A9traqoTBqJA7MYsVv1xiqXA
         lVIMfKGNFTNepv2aRGvMwA1gp+qjpuFgixNXCrnPGuJOp6ImbcjtrAslLX3wRs4wDMm0
         deSpeVEhfvbGikq+KDQZxtvs3IoKtm8fC7O/nEe3N12tD+jpeb9L81b2HwGecqQwmbNW
         a1kw==
X-Gm-Message-State: AOJu0Yy6CNXxS4wdmbhnk+a2828wr/31dBPUsIoBG1fdWH/aTOBtHl0G
	rrWdLnXbA6VXe4RmDbIIIG50bRMJqldjUvfX1JjJavpkTmAab/qh
X-Google-Smtp-Source: AGHT+IESPS8xjdoipfNUChz4GSugbSbyCKdjYwYdN80IftAu/Ulr/4Wn5fcbU/c6wXTMzQQLSYdN6w==
X-Received: by 2002:ac2:4c4d:0:b0:52c:e17c:3741 with SMTP id 2adb3069b0e04-53b23dde253mr2112183e87.5.1729793412280;
        Thu, 24 Oct 2024 11:10:12 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5988sm1419774e87.2.2024.10.24.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:58 +0300
Message-ID: <20241024180958.6724-1-vladimirputin693389@gmail.com>
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
